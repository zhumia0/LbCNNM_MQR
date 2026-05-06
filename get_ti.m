function [time_interval] = get_ti(class)
if (strcmp(class,'Yearly') || strcmp(class,'Weekly') ||strcmp(class,'Daily'))
    time_interval = 1;
end
if (strcmp(class,'Monthly'))
    time_interval = 12;
end
if (strcmp(class,'Quarterly'))
    time_interval = 4;
end
if (strcmp(class,'Hourly'))
    time_interval = 24;
end
end