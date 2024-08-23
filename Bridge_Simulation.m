% Bridge Simulation: Simply Supported Beam under Load Conditions
clear; clc;

% Bridge Parameters (Beam Model)
L = input('Enter the length of the bridge (in meters): ');  % Length of the bridge (m)
EI = input('Enter the flexural rigidity (EI) of the beam (N*m^2): ');  % Flexural rigidity (EI) in N*m^2

% Number of points to simulate along the bridge span
nPoints = 100;
x = linspace(0, L, nPoints);  % Discretized bridge span

% Load Conditions (Vehicle Loads)
nLoads = input('Enter the number of point loads acting on the bridge: ');  % Number of loads
P = zeros(1, nLoads);
a = zeros(1, nLoads);

for i = 1:nLoads
    P(i) = input(['Enter the magnitude of load ', num2str(i), ' (in Newtons): ']);
    a(i) = input(['Enter the position of load ', num2str(i), ' from the left end (in meters): ']);
end

% Beam Deflection Calculation using Superposition Method for Simply Supported Beam
% Formula for deflection due to point load P at distance a from left end: 
% v(x) = (P*a*(L^2 - a^2 - x^2)) / (6*EI*L)

deflection = zeros(1, nPoints);

for i = 1:nLoads
    for j = 1:nPoints
        if x(j) <= a(i)
            deflection(j) = deflection(j) + (P(i) * a(i) * (L^2 - a(i)^2 - x(j)^2)) / (6 * EI * L);
        else
            deflection(j) = deflection(j) + (P(i) * (L - a(i)) * (L^2 - (L - a(i))^2 - (L - x(j))^2)) / (6 * EI * L);
        end
    end
end

% Plotting the deflection curve
figure;
plot(x, deflection, '-o');
title('Bridge Deflection under Load');
xlabel('Position along the bridge (m)');
ylabel('Deflection (m)');
grid on;

% Evaluate Maximum Deflection
[maxDeflection, maxDeflectionIndex] = max(abs(deflection));
fprintf('The maximum deflection is %.4f meters at position %.2f meters.\n', maxDeflection, x(maxDeflectionIndex));

% Dynamic Simulation using Time-Dependent Loads (optional)
t = linspace(0, 10, 100);  % Time vector (10 seconds simulation)
loadPositions = linspace(0, L, length(t));  % Simulate load moving across the bridge

% Initialize displacement over time
displacement = zeros(length(t), nPoints);

for k = 1:length(t)
    for i = 1:nLoads
        loadPos = loadPositions(k);  % Moving load position
        for j = 1:nPoints
            if x(j) <= loadPos
                displacement(k, j) = displacement(k, j) + (P(i) * loadPos * (L^2 - loadPos^2 - x(j)^2)) / (6 * EI * L);
            else
                displacement(k, j) = displacement(k, j) + (P(i) * (L - loadPos) * (L^2 - (L - loadPos)^2 - (L - x(j))^2)) / (6 * EI * L);
            end
        end
    end
end

% Create an animation of the dynamic response
figure;
for k = 1:length(t)
    plot(x, displacement(k, :), '-o');
    title(['Dynamic Bridge Deflection at t = ', num2str(t(k)), ' seconds']);
    xlabel('Position along the bridge (m)');
    ylabel('Deflection (m)');
    grid on;
    ylim([min(displacement(:)), max(displacement(:))]);
    pause(0.1);  % Control the speed of the animation
end

