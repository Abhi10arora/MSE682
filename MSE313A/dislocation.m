normal = (1.0/sqrt(3))*[1 1 1];
x_cap = (1.0/sqrt(2))*[1 -1 0];
y_cap = (1.0/sqrt(6))*[-1 -1 2];
[X,Y] = meshgrid(50:130,50:130);
file = fopen('input.txt','r');
file1 = fopen('line.txt','r');
sigma = zeros(3);
for i = 1:3
    for j = 1:3
    sigma(i,j) = fscanf(file, '%f',1);
    end
end
B = zeros([1 3]);
test = 0;
for i = 1:3
    B(i) = fscanf(file, '%f',1);
    test = test + B(i)*normal(i);
end
if test ~= 0
    disp('Invalid Burger Vector');
    return;
end

line_ = fscanf(file1, '%f', [2 inf]);

loop = 0;
if line_(1,length(line_(1,:))) == line_(1,1) && line_(2,length(line_(2,:))) == line_(2,1)
    loop = 1;
end

for t = 1:50
    Z = X - X + 5;
    refreshdata
    h = surf(X,Y,Z);
    x0 = line_(1,:);
    y0 = line_(2,:);
    line(x0,y0,5*ones(size(x0)),'linewidth',2,'color','r');
    drawnow
    pause(.1)
    
    if loop == 0
        for i = 1:(length(line_(1,:)))
        splines = cscvn(line_);
        deri = fnder(splines);
        flag = fnval(deri, splines.breaks(i));
        slope = flag(2)/flag(1);
        temp = sigma*transpose(B);
        temp_1 = (1.0/sqrt(1 + slope*slope))*x_cap + (slope/sqrt(1 + slope*slope))*y_cap;
        tot_force = cross(temp, temp_1);
        force = tot_force - normal*dot(tot_force, normal);
        %force = force/norm(force);
        line_(1,i) = line_(1,i) + dot(force, x_cap);
        line_(2,i) = line_(2,i) + dot(force, y_cap);
        end
    elseif loop == 1
        for i = 1:(length(line_(1,:))-1)
        splines = cscvn(line_);
        deri = fnder(splines);
        flag = fnval(deri, splines.breaks(i));
        slope = flag(2)/flag(1);
        temp = sigma*transpose(B);
        temp_1 = (1.0/sqrt(1 + slope*slope))*x_cap + (slope/sqrt(1 + slope*slope))*y_cap;
        tot_force = cross(temp, temp_1);
        force = tot_force - normal*dot(to   t_force, normal);
        %force = force/norm(force);
        line_(1,i) = line_(1,i) + dot(force, x_cap);
        line_(2,i) = line_(2,i) + dot(force, y_cap);
        end
        line_(1,length(line_(1,:))) = line_(1,1);
        line_(2,length(line_(2,:))) = line_(2,1);
    end
    disp(line_);
end