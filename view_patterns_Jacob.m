% simply draws patterns to the screen so you can see what is being tested

params = prep_params_default;

disp('MODEL LIST:')
disp('1. whites standard howe matchup')
disp('2. whites howe var b')
disp('3. whites howe')
disp('4. whites howe var d')
disp('5. sbc howe matchup')
disp('6. whites anderson')
disp('7. circ whites thin')
disp('8. ring whites thin new')
disp('9. whites zigzag howe matchup')
disp('10. whites jacob howe matchup')
disp('11. whites jacob howe matchup 2')
result = input('Select a pattern to view (1-11): ');

figure

if result == 1
    model = make_whites_standard_howe_matchup(params);
    imshow(model.img)
elseif result == 2
    model = make_whites_howe_var_b(params);
    imshow(model.img)
elseif result == 3
    model = make_whites_howe(params);
    imshow(model.img)
elseif result == 4
    model = make_whites_howe_var_d(params);
    imshow(model.img)
elseif result == 5
    model = make_sbc_howe_matchup(params);
    imshow(model.img)
elseif result == 6
    model = make_whites_anderson(params);
    imshow(model.img)
elseif result == 7
    model = make_circ_whites_thin(params);
    imshow(model.img)
elseif result == 8
    model = make_ring_whites_thin_new(params);
    imshow(model.img)
elseif result == 9
    model = make_whites_zigzag_howe_matchup(params);
    imshow(model.img)
elseif result == 10
    model = make_whites_jacob_howe_matchup(params);
    imshow(model.img)
elseif result == 11
    model = make_whites_jacob_howe_matchup_2(params);
    imshow(model.img)

end



%     ''
%     'loadimage(''texture sbc.png'', 6, 0)'
%     'loadimage('''', 2,1)';
%     'loadImage(''whitenoise.png'', 255, 1)'
%     'make_ring_whites_thin_new_big';
