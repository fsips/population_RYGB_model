function [chars] = determine_char(cond)

chars.fasting_pl_pu   = cond.x(end,69);
chars.fasting_pl_pc   = cond.x(end,70);
chars.fasting_pl_su   = cond.x(end,71);
chars.fasting_pl_sc   = cond.x(end,72);

chars.fasting_pl_p    = chars.fasting_pl_pu +chars.fasting_pl_pc; 
chars.fasting_pl_s    = chars.fasting_pl_su +chars.fasting_pl_sc; 
chars.fasting_pl      = chars.fasting_pl_p  +chars.fasting_pl_s; 

chars.synthesis       = cond.v(end).li_x_pc;

begin_meal            = find(cond.t >= (cond.t(end)-24*60), 1, 'first'); 
end_meal              = find(cond.t >= (cond.t(end)-(24-cond.rythm(1))*60), 1, 'first'); 

chars.meal_t          = cond.t(begin_meal:end_meal);
chars.meal_pl         = sum(cond.x(begin_meal:end_meal,69:72)')';

min30_meal            = find(cond.t >= (cond.t(end)-(24-0.5)*60), 1, 'first'); 
chars.meal_30         = sum(cond.x(min30_meal,69:72));

chars.meal_max        = max(chars.meal_pl);
loc_max               = find(chars.meal_pl == max(chars.meal_pl));
chars.mean_max_loc    = chars.meal_t(loc_max);

