function series_cell = gen_maps(map_names, map_length, map_params, map_inits, map_eta)
    num_maps = length(map_names);
    series_cell = {};
    for i = 1:num_maps
        map_name = map_names{i}; % a string
        map_param = map_params{i}; % a vector of parameters
        map_init = map_inits{i}; % a number
        series_matrix = NaN(length(map_param), map_length);
        if strcmp(map_name, 'AR')
            for j = 1:length(map_param)
                series_matrix(j, :) = MkSg_AR(map_length, map_param(j), map_eta);
            end
        else
            for j = 1:length(map_param)
                    series_matrix(j, :) = MkSg_Map(map_name, map_length, map_init, map_param(j), map_eta);
            end
        end
        series_cell{i} = series_matrix;
    end
end