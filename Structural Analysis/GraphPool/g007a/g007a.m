classdef g007a < model
    %% Linear T.I. airplane model found in
    % Izadi-Zamanabadi, R. (2002).
    % Structural analysis approach to fault diagnosis with application to fixed-wing aircraft motion.
    % Proceedings of the 2002 American Control Conference (IEEE Cat. No.CH37301), 5, 3949–3954. doi:10.1109/ACC.2002.1024546
    
    % x1dot = a11 x1 + a13 x3 + a14 x4 + a16 x6
    % x2dot = a21 x1 + a22 x2 + a23 x3 + a27 x7
    % x3dot = a31 x1 + a33 x3 + a36 x6
    % x4dot = x2
    % x5dot = x3 + a55 x5
    % x6dot = a66 x6 + b61 u1
    % x7dot = a77 x7 + b72 u2
    % y1 = x1
    % y2 = x4
    % y3 = x5
    methods
        function this = g007a()
            this.name = 'g007a';
            this.description = 'Linear T.I. airplane model found in "Structural analysis approach to fault diagnosis with application to fixed-wing aircraft motion"';
            
            con = [...
                {'fault x1_dot x1 x3 x4 x6'};...
                {'fault x2_dot x2 x1 x3 x7'};...
                {'fault x3_dot x1 x3 x6'};...
                {'fault x4_dot x2'};...
                {'fault x5_dot x3 x5'};...
                {'fault x6_dot x6 inp u1'};...
                {'fault x7_dot x7 inp u2'};...
                ];
            
            der = [...
                {'int x1 dot x1_dot'};... % x1_dot is the derivative of x1
                {'int x2 dot x2_dot'};...
                {'int x3 dot x3_dot'};...
                {'int x4 dot x4_dot'};...
                {'int x5 dot x5_dot'};...
                {'int x6 dot x6_dot'};...
                {'int x7 dot x7_dot'};...
                ];
            
            msr = [...
                {'msr y1 x1'};...
                {'msr y2 x4'};...
                {'msr y3 x5'};...
                ];
            
            this.constraints = [...
                {con},{'c'};...
                {der},{'d'};...
                {msr},{'s'};...
                ];
            
            this.coordinates = [];
            
        end
        
    end
    
end
