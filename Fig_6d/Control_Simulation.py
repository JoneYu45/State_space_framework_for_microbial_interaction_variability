# Import modules
import numpy as np
import os
import pandas as pd
from optparse import OptionParser
from local_functions_20200813 import make_weights, weight_data, select_frequent_dominate_genera

def predict_shift_after_control(abund, empirical_states, target_abund,
                                control_node, control_input,
                                theta, weighted_posshifts):
    print('\rPredict shift at state No. %s after controlling' % str(target_abund + 1), flush=True, end='')
    # Make input for the elastic_net using both time series and empirical data
    ## Predict the possible shift after control
    ### Select the wanted genera according to the time series data
    wanted_empirical_state = pd.DataFrame(empirical_states, columns=abund.columns)
    wanted_empirical_state.fillna(0, inplace=True)
    ### Combine the time series and empirical data except state at time t and t+1
    if target_abund == abund.shape[0] - 1:
        abund == abund
    else:
        abund.drop([target_abund+1])
    wanted_abund = abund.append(wanted_empirical_state)

    ### Input a control of the target state
    target_state = np.array(abund.iloc[target_abund, :])
    target_state[control_node] = target_state[control_node] + control_input

    ### Find refernce shift
    reference_shifts = wanted_abund.drop(wanted_abund.index[target_abund])

    ### Calculate the weights
    E_dist = np.array(np.sqrt(np.sum((reference_shifts - target_state) ** 2, axis=1)))
    w = np.array(make_weights(E_dist, theta))
    ### Predict and collect weighted possible shift
    weighted_posshift = np.dot(w, reference_shifts) / sum(w)
    weighted_posshifts.append(weighted_posshift)

    return weighted_posshifts

def predict_shift_without_control(abund, empirical_states, target_abund,
                                control_node, control_input,
                                theta, weighted_posshifts):
    print('\rPredict shift at state No. %s without control' % str(target_abund + 1), flush=True, end='')
    # Make input for the elastic_net using both time series and empirical data
    ## Predict the possible shift after control
    ### Select the wanted genera according to the time series data
    wanted_empirical_state = pd.DataFrame(empirical_states, columns=abund.columns)
    wanted_empirical_state.fillna(0, inplace=True)
    ### Combine the time series and empirical data except state at time t and t+1
    if target_abund == abund.shape[0] - 1:
        abund == abund
    else:
        abund.drop([target_abund+1])
    wanted_abund = abund.append(wanted_empirical_state)

    ### Locate target state
    target_state = np.array(abund.iloc[target_abund, :])

    ### Find refernce shift
    reference_shifts = wanted_abund.drop(wanted_abund.index[target_abund])

    ### Calculate the weights
    E_dist = np.array(np.sqrt(np.sum((reference_shifts - target_state) ** 2, axis=1)))
    w = np.array(make_weights(E_dist, theta))
    ### Predict and collect weighted possible shift
    weighted_posshift = np.dot(w, reference_shifts) / sum(w)
    weighted_posshifts.append(weighted_posshift)

    return weighted_posshifts

def calculate_success_rate(target_node, control_node, control_input):
    # Predict the possible shifts after and without control
    weighted_posshifts_controlled = []
    weighted_posshifts_without_control = []
    abund = abund0
    for target_abund in range(abund.shape[0]):
        abund = abund0
        weighted_posshifts_controlled = predict_shift_after_control(abund, empirical_states, target_abund,
                                                                    control_node, control_input,
                                                                    theta_ps, weighted_posshifts_controlled)
        weighted_posshifts_without_control = predict_shift_without_control(abund, empirical_states, target_abund,
                                                                           control_node, control_input,
                                                                           theta_ps, weighted_posshifts_without_control)
    weighted_posshifts_controlled = np.matrix(weighted_posshifts_controlled)
    weighted_posshifts_without_control = np.matrix(weighted_posshifts_without_control)

    # Find out whether the target nodes are changed as designed
    results = weighted_posshifts_controlled[:, target_node] - weighted_posshifts_without_control[:, target_node]
    odds_for_increase = len(np.where(np.array(results) > 0)[0]) / len(np.array(results)) * 100
    odds_for_decrease = len(np.where(np.array(results) < 0)[0]) / len(np.array(results)) * 100

    return odds_for_increase, odds_for_decrease

if __name__ == '__main__':
    # Imnput data and setting
    parse = OptionParser()
    parse.add_option('-I', '--input', dest='input', default='../inputs/HK_Daily_DaDa2.csv')  # 56.21314_10.24247
    parse.add_option('-O', '--output', dest='output', default='../outputs/test_ps')
    parse.add_option('-R', '--reference', dest='reference', default='../inputs/level_7_Midas_collaspe.csv')
    parse.add_option('-D', '--dominate', dest='dominate', default=1)
    parse.add_option('-Z', '--zero', dest='zero', default=50)
    parse.add_option('-P', '--thtps', dest='thtps', default=1)
    parse.add_option('-C', '--control', dest='control', default=0.5)
    (options, args) = parse.parse_args()

    input = options.input
    output_dir = options.output
    empirical_state_loc = options.reference
    dominate_threshold = float(options.dominate)  # More than threshold
    zero_frequency_threshold = float(options.zero)  # Less than threshold
    theta_ps = float(options.thtps)
    control_input = float(options.control)

    # Make output directory
    print('Making output directory...')
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    # Select frequent and dominate genera
    print('Selecting frequent and dominate genera...')
    abund0 = select_frequent_dominate_genera(input, dominate_threshold, zero_frequency_threshold, True)
    print('Output analyzed OTUs')
    abund0.to_csv('/'.join([options.output, 'abund.csv']))

    # Select the wanted genera in empirical states
    print('Selecting the wanted genera in empirical states...')
    empirical_states = select_frequent_dominate_genera(empirical_state_loc, dominate_threshold,
                                                       zero_frequency_threshold, False)

    # Prepare output table
    output = []

    # Design objectives and calculate success rate

    for control_node in range(abund0.shape[1]):
        for target_node in range(abund0.shape[1]):
            if control_node != target_node:
                pair = '_'.join((str(control_node), str(target_node)))
                print('\nSimulating pair %s' % pair)
                odds_for_increase, odds_for_decrease = calculate_success_rate(target_node, control_node, control_input)
                output.append([target_node, control_node, odds_for_increase, odds_for_decrease])

    # Output result
    print('\nOuput reuslt')
    output = pd.DataFrame(output, columns=['Target', 'Control', 'Odds_in', 'Odds_de'])
    output.to_csv('/'.join((output_dir, 'control_efficacy_05_t10.csv')))
    print('Done')
