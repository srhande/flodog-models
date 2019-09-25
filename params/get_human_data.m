function [ data ] = get_human_data()
%HUMAN_DATA returns values and stimulus names for recorded human trial data
%   Detailed explanation goes here
% 5/31/14 Eric Morgan

data = containers.Map();


data('WE-thick') = 1;
data('WE-thin-wide') = 1.1;
data('WE-Anderson') = 1.54;
data('WE-Howe') = 0;
data('Grating induction') = 1.49;
data('SBC-Large') = 2.72;
data('SBC-Small') = 4.73;
data('Todorovic-equal') = 0.53;
data('Todorovic-in-large') = 0.57;
data('Todorovic-in-small') = 1.05;
data('Todorovic-out') = 0.37;
data('Checkerboard-0.16') = 1.78;
data('Checkerboard-0.94') = 0.68;
data('Checkerboard-2.1') = 1.36;
data('Corrugated Mondrian') = 2.6;
data('Benary cross') = 2.2;
data('Todorovic Benary 1-2') = 2.86;
data('Todorovic Benary 3-4') = 2.28;
