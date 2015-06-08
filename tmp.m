figure, hold on;

p1 = plot(PWTT_bps_peak(:, 1),PWTT_bps_peak(:, 2) , 'ob-')
p2 = plot(PWTT_bps_key(:, 1),PWTT_bps_key(:, 2) , 'r*-')
p3 = plot(PWTT_bps_valley(:, 1),PWTT_bps_valley(:, 2) , 'gx-')
p4 = plot(PWTT_bps_rise(:, 1),PWTT_bps_rise(:, 2) , 'kd-')

legend([p1, p2, p3, p4], {'PTT_P', 'PTT_O', 'PTT_T', 'PTT_F'});