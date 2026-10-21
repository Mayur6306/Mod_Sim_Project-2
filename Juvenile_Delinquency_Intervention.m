
% Juvenile Delinquency Model
% MTH/CSC 4170 - Project 2

%% Clear workspace
clear all;
close all;

%% Initialize variables

% Set up time increment and time vector
deltaX = 0.01;       % time step (years)
tf = 100;            % final time (years)
x = 0:deltaX:tf;     % time vector (years)

% Constants
N0 = 10000;          % total juvenile population
b = 0.60;            % gang recruitment rate (1/year)
a = 0.14;            % independent delinquency rate (1/year)
r = 0.235;           % arrest rate (1/year)
% r = 0.296;           % intervention arrest rate (1/year)
u = 3;               % release rate (1/year)
m = 1/5;             % aging rate (1/year)
v = 0;             % intervention rate (1/year)

%% Run both scenarios

for scenario = 1:2

    % Part A and Part B parameters
    if scenario == 1
        p = 1.00;    % peer pressure rate (1/year)
        q = 0.30;    % gang departure rate (1/year)
        scenarioName = 'Part A: Original Population';
    else
        p = 0.42;    % peer pressure rate (1/year)
        q = 0.50;    % gang departure rate (1/year)
        scenarioName = 'Part B: Higher Socioeconomic Population';
    end

    % Set up stock variables and initial conditions
    S(1) = 0.905 * N0;  % Susceptible
    G(1) = 0.080 * N0;  % Non-delinquent gang members
    D(1) = 0.010 * N0;  % Delinquent gang members
    L(1) = 0.005 * N0;  % Arrested and law-enforced
    V(1) = 0;           % Protected through early intervention

    %% Main loop
    for i = 2:length(x)

        % Compute transition rates (people per year)
        % Forward Euler

        % Susceptible to gang member
        S_to_G = (b / N0) * S(i-1) * (G(i-1) + D(i-1));

        % Gang member to susceptible
        G_to_S = q * G(i-1);

        % Gang member to delinquent through peer pressure
        G_to_D_Peer = (p / N0) * G(i-1) * D(i-1);

        % Gang member to delinquent through personal issues
        G_to_D_Personal = a * G(i-1);

        % Delinquent to law-enforced
        D_to_L = r * D(i-1);

        % Law-enforced released equally to S, G, and D
        L_to_S = (u / 3) * L(i-1);
        L_to_G = (u / 3) * L(i-1);
        L_to_D = (u / 3) * L(i-1);

        % Susceptible to immune
        S_to_V = v * S(i-1);

        % Aging into and out of the population
        Enter_S = m * N0;

        S_Out = m * S(i-1);
        V_Out = m * V(i-1);
        G_Out = m * G(i-1);
        D_Out = m * D(i-1);
        L_Out = m * L(i-1);

        % Update populations using Forward Euler
        S(i) = S(i-1) + deltaX * ...
            (Enter_S + G_to_S + L_to_S - S_to_G - S_Out - S_to_V);

        V(i) = V(i-1) + deltaX * (S_to_V - V_Out);

        G(i) = G(i-1) + deltaX * ...
            (S_to_G + L_to_G - G_to_S - G_to_D_Peer ...
            - G_to_D_Personal - G_Out);

        D(i) = D(i-1) + deltaX * ...
            (G_to_D_Peer + G_to_D_Personal + L_to_D ...
            - D_to_L - D_Out);

        L(i) = L(i-1) + deltaX * ...
            (D_to_L - L_to_S - L_to_G - L_to_D - L_Out);

    end

    %% Plot Solutions

    % First Plot: All Populations
    figure()
    plot(x, S, 'k', ...
         x, V, 'g', ...
         x, G, 'b', ...
         x, D, 'r', ...
         x, L, 'm', 'LineWidth', 3.0);

    xlabel('Time (years)', 'fontsize', 18);
    ylabel('Population', 'fontsize', 18);

    legend({'Susceptible', 'Immune', 'Non-Delinquent Gang Members', ...
            'Delinquent Gang Members', 'Law-Enforced'}, ...
            'fontsize', 12, 'location', 'best');

    title([scenarioName ' - All Populations'], 'fontsize', 20);

    


    % Second Plot: Gang and Law-Enforced Populations
    figure()
    plot(x, G, 'b', ...
         x, D, 'r', ...
         x, L, 'm', 'LineWidth', 3.0);

    xlabel('Time (years)', 'fontsize', 18);
    ylabel('Population', 'fontsize', 18);

    legend({'Non-Delinquent Gang Members', ...
            'Delinquent Gang Members', 'Law-Enforced'}, ...
            'fontsize', 12, 'location', 'best');

    title([scenarioName ' - Gang and Law-Enforced Populations'], ...
          'fontsize', 20);

    %% Equilibrium Percentages

    disp(scenarioName)
    disp(['Susceptible: ', num2str(S(end)/N0*100), '%'])
    disp(['Non-Delinquent Gang Members: ', num2str(G(end)/N0*100), '%'])
    disp(['Delinquent Gang Members: ', num2str(D(end)/N0*100), '%'])
    disp(['Law-Enforced: ', num2str(L(end)/N0*100), '%'])
    disp(' ')

    % Third Plot: Susceptible and Immune
    figure()
    plot(x, (S + V), 'k', ...
        x, G, 'b', ...
        x, D, 'r', ...
        x, L, 'm', 'LineWidth', 3.0);

    xlabel('Time (years)', 'fontsize', 18);
    ylabel('Population', 'fontsize', 18);

    legend({'Susceptible and Immune', 'Non-Delinquent Gang Members', ...
        'Delinquent Gang Members', 'Law-Enforced'}, ...
        'fontsize', 12, 'location', 'best');

    title([scenarioName ' - All Populations'], 'fontsize', 20);

end
