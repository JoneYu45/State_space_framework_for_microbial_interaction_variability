#Environment setup
import pandas as pd
import os

def Transfer_J_abd_1(J_abd_pah, theta, time_point, input_type, output_file):
    #Input Jacobian matrices and abundance matrix
    abd = pd.read_csv(J_abd_pah + '/abund.csv', index_col=0)
    network_name = 'Graph_' + theta + '_' + str(time_point)

    #Write FINDER input
    df = open(output_file, 'w')
    df.write('graph [\n')
    df.write('  name "%s"\n' % network_name)
    ##Write node info
    for i in range(abd.shape[1]):
        if input_type == 'uniform_cost':
            df.write('  node [\n    id %d\n    label "%s"\n  ]\n' %
                     (i, i))
                     # (i, abd.columns[i].replace(' ', '_')))
        else:
            df.write('  node [\n    id %d\n    label "%s"\n    weight %.3f\n  ]\n' %
                     (i, i, abd.iloc[time_point - 1, i]))
                     # (i, abd.columns[i].replace(' ', '_'), abd.iloc[time_point-1,i]))

    ##Write edge info
    for i in range(abd.shape[1]):
        J_file = J_abd_pah + '/coefs/' + str(i) + '_' + theta + '_coefs.csv'
        J_matrix_i = pd.read_csv(J_file, index_col=0)

        for j in range(J_matrix_i.shape[1]):
            if J_matrix_i.iloc[time_point, j] != 0 and i != j:
                df.write('  edge [\n    source %d\n    target %d\n  ]\n' %
                         (j, i))
                # df.write('  edge [\n    source %d\n    target %d\n    weight %.6f\n  ]\n' %
                #          (j, int(i), abs(J_matrix_i.iloc[time_point, j])))

    df.write(']\n')
    df.close()

def Transfer_J_abd_2(J_abd_pah, output_file):
    ##Input abundance data
    abd = pd.read_csv(J_abd_pah + '/abund.csv', index_col=0)
    ##Write FINDER txt
    df = open(output_file, 'w')

    for i in range(abd.shape[1]):
        ##Read Jacobian matrices
        J_file = J_abd_pah + '/coefs/' + str(i) + '_' + theta + '_coefs.csv'
        J_matrix_i = pd.read_csv(J_file, index_col=0)

        for j in range(J_matrix_i.shape[1]):
            if J_matrix_i.iloc[time_point, j] != 0 and i != j:
                df.write('%s %s {}\n' %
                         (j, i))
                         # (abd.columns[j].replace(' ', '_'), abd.columns[i].replace(' ', '_')))

    df.close()

if __name__=="__main__":
    # Parameters concerned
    theta = '1'
    J_abd_pah = '../Output/LWR_output_demo'
    input_type = ['uniform_cost', 'random_cost', 'degree_cost'][2]

    #Transfer J_abd to FINDER input
    for time_point in range(259):
        ##Name output files
        print('Processing time point %d' % time_point)
        save_dir = './FINDER_input_2022-02-28/'
        output_file_1 = 'HK' + str(time_point)
        output_file_2 = 'HK' + str(time_point) + '.txt'

        ##Make output directory
        if not os.path.exists(save_dir):
            os.mkdir(save_dir)
        output_file_1 = save_dir + '/' + output_file_1
        output_file_2 = save_dir + '/' + output_file_2

        ##Make file
        Transfer_J_abd_1(J_abd_pah, theta, time_point, input_type, output_file_1)
        Transfer_J_abd_2(J_abd_pah, output_file_2)
