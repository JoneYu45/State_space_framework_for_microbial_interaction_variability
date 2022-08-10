#Environment setup
import turtle
import math
import random
import seaborn as sns
import numpy as np
import pandas as pd
import os, re

def cal_d(x,y, i, len, pi, curve):
    return ((x - y) / len * i + np.sign(x - y) * math.sin(pi / len * i) * curve)

def draw_node(p, out_color='black', in_color='#969696', size=50):
    turtle.up()
    turtle.setpos(p[0], p[1])
    turtle.down()
    turtle.pencolor(out_color)
    turtle.dot(size+5)
    turtle.pencolor(in_color)
    turtle.dot(size)

def draw_edge(p1, p2, len=259, edge_width=10, weight=[], alpha=0.5):
    #Locate source node
    turtle.up()
    turtle.setpos(p1[0], p1[1])
    turtle.down()

    # Draw edge
    for i in range(len):
        turtle.width(edge_width)  # turtle.width(abs(weight/5))
        turtle.pencolor(colors[int(weight[i]) + 1])
        dx = cal_d(p2[0], p1[0], i, len, pi, curve)
        dy = cal_d(p2[1], p1[1], i, len, pi, curve)
        turtle.goto(dx + p1[0], dy + p1[1])


#Parameter setting
# colors = sns.diverging_palette(145,280, s=85, l=25, n=3)
colors = np.array(['#2C7BB6', '#FFFFBF', '#D7191C'])
node_size = 10
edge_width = 3
len =259
edge_length = 259
turtle.bgcolor('black')
# turtle.penColor("rgba(127, 255, 0, 0.5)")
turtle.speed(10)

pi = 3.14
curve = 50
tht = 2

#Input data and process
df = pd.DataFrame(columns=['Source', 'Target', 'Day', 'J'])
Data_path = 'E:\\学习\\研究生\\研究生课题\\大规模污泥群落数据统计\\数据\\DaDa_analysis\\Midas_analysis\\HKD_Midas_L7\\coefs'
files = os.listdir(Data_path)
coefs_tht = [x for x in files if '_'+str(tht)+'_' in x]
for coef_tht in coefs_tht:
    print('Add data from %s' % coef_tht)
    data = pd.read_csv(Data_path + '\\' + coef_tht, index_col=0)
    for i in range(data.shape[1]):
        for j in range(data.shape[0]):
            if str(i) != coef_tht.replace('_'+str(tht)+'_coefs.csv', ''):
                print('\rAdding data %d / %d and %d / %d' % (i, data.shape[1]-1, j, data.shape[0]-1),
                      end='', flush=True)
                add_data = pd.Series({'Source': i,
                                      'Target': coef_tht.replace('_'+str(tht)+'_coefs.csv', ''),
                                      'Day': j,
                                      'J': data.iloc[j,i]})
                df = df.append(add_data, ignore_index=True)
    print('')

#Make node list
nodes_list = []
for i in range(data.shape[1]):
    angle = 2*pi*i/data.shape[1]
    nodes_list.append(np.array([edge_length*np.cos(angle), edge_length*np.sin(angle)]))

#Draw edges
for i in range(data.shape[1]):
    for j in range(data.shape[1]):
        if i != j:
            df_i = df.loc[df['Target'] == str(i)]
            df_ij = df_i.loc[df_i['Source'] == j]
            draw_edge(nodes_list[i], nodes_list[j], len=len, edge_width=edge_width,
                      weight=np.array(np.sign(df_ij['J'])))

#Draw nodes
for i in range(data.shape[1]):
    draw_node(nodes_list[i])

turtle.hideturtle()
turtle.done()
