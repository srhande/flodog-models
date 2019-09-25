% simply draws patterns to the screen so you can see what is being tested

params = prep_params_default;

disp('MODEL LIST:')
disp('1. Multiple Illusions')
disp('2. Textured SBC')
disp('3. Necker SBC')
disp('4. White Noise')
disp('5. Thin Rings (big)')
disp('6. Local Opposing Energy')
disp('7. WE-Howe')
disp('8. WE-Andersen')
disp('9. WE-thick')
disp('10. Dual Whites Illusion')
disp('11. SBC-Large')
disp('12. SBC-Small')
disp('13. WE-thin-wide')
disp('14. Grating Induction')
disp('15. Todorovic-in-small')
disp('16. Todorovic-in-large')
disp('17. Todorovic-equal')
disp('18. Todorovic-out')
disp('19. Todorovic Benary Cross')
disp('20. Benary Cross')
disp('21. Todorovic Benary 1-2')
disp('22. Bullseye-thin')
disp('23. Bullseye-thick')
disp('24. CSF chart')
result = input('Select a pattern to view (1-23): ');

figure

if result == 1
    model = loadimage('./testpatterns/many_illusion.png', 6,1);
    imshow(model.img)
elseif result == 2
    model = loadimage('./testpatterns/texture sbc.png', 6, 0);
    imshow(model.img)
elseif result == 3
    model = loadimage('./testpatterns/necker_sbc.PNG', 6, 0);
    imshow(model.img)
elseif result == 4
    model = loadimage('./testpatterns/whitenoise.png', 6, 0);
    imshow(model.img)
elseif result == 5
    model = make_ring_whites_thin_new_big(params);
    imshow(model.img)
elseif result == 6
    model = make_local_opposing_energy(params);
    imshow(model.img)
elseif result == 7
    model = make_whites_howe(params);
    imshow(model.img)
elseif result == 8
    model = make_ring_whites_thin_new_big(params);
    imshow(model.img)
elseif result == 9
    model = make_bm_whites_thick(params);
    imshow(model.img)
elseif result == 10
    model = make_dual_whites(params);
    imshow(model.img)
elseif result == 11
    model = make_sbc_large(params);
    imshow(model.img)
elseif result == 12
    model = make_sbc_small(params);
    imshow(model.img)
elseif result == 13
    model = make_bm_whites_thin_wide(params);
    imshow(model.img)
elseif result == 14
    model = make_small_grating_induction(params);
    imshow(model.img)
elseif result == 15
    model = make_todorovic(params, 'in-small');
    imshow(model.img)
elseif result == 16
    model = make_todorovic(params, 'in-large');
    imshow(model.img)
elseif result == 17
    model = make_todorovic(params, 'equal');
    imshow(model.img)
elseif result == 18
    model = make_todorovic(params, 'out');
    imshow(model.img)
elseif result == 19
    model = make_todorovic_benary_cross(params);
    imshow(model.img)
elseif result == 20
    model = make_benary_cross(params);
    imshow(model.img)
elseif result == 21
    model = make_todorovic_benary_cross_1_2(params);
    imshow(model.img)
elseif result == 22
    model = make_bullseye_rect_thin(params);
    imshow(model.img)
elseif result == 23
    model = make_bullseye_rect_thick(params);
    imshow(model.img)
elseif result == 24
    [model, limitline] = CreateCSFChart(1024, 1024);
    imshow(model)
end



%     ''
%     'loadimage(''texture sbc.png'', 6, 0)'
%     'loadimage('''', 2,1)';
%     'loadImage(''whitenoise.png'', 255, 1)'
%     'make_ring_whites_thin_new_big';
