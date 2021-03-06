classdef g005a < model
    %% UAV model described in
    %Fravolini, M., Campa, G., & Napolitano, M. (2008).
    %Design of Redundancy Relations for Unmanned Aerial Vehicle FDI.
    %AIAA Guidance, Navigation and Control Conference and Exhibit, (August), 1–12.
    %Retrieved from http://arc.aiaa.org/doi/abs/10.2514/6.2008-7421
    
    methods
        function this = g005a()
            this.name = 'g005a';
            this.description = 'UAV model from "Design of Redundancy Relations for Unmanned Aerial Vehicle FDI, modified to produce less MTESs"';
            
            kin = [...
                {'dot_V ni a ni b Fx ni Fy ni Fz par m expr dot_V-(Fx*cos(a)*cos(b)+Fy*sin(b)+Fz*sin(a)*cos(b))/m'};...
                {'dot_a ni a ni b ni V q ni p ni r ni Fx Fz par m expr dot_a-(-Fx*sin(a)+Fz*cos(a))/(m*V*cos(b))-q+(p*cos(a)+r*sin(a))*tan(b)'};...
                {'dot_b ni a ni b ni V ni p r ni Fx Fy ni Fz par m expr dot_b-(-Fx*cos(a)*sin(b)+Fy*cos(b)-Fz*sin(a)*sin(b))/(m*V)-p*sin(a)+r*cos(a)'};...
                {'dot_p ni p ni q ni r L N par Pl par Pn par Ppq par Pqr expr dot_p-Pl*L-Pn*N-Ppq*p*q-Pqr*q*r'};...
                {'dot_q ni p ni r M par Qm par Qpp par Qpr par Qrr expr dot_q-Qm*M-Qpp*p^2-Qpr*p*r-Qrr*r^2'};...
                {'dot_r ni p ni q ni r L N par Rl par Rn par Rpq par Rqr expr dot_r-Rl*L-Rn*N-Rpq*p*q-Rqr*q*r'};...
                {'dot_Psi ni Phi ni q r ni Theta expr dot_Psi-(q*sin(Phi)+r*cos(Phi))/cos(Theta)'};...
                {'dot_Theta q ni Phi ni r expr dot_Theta-q*cos(Phi)+r*sin(Phi)'};...
                {'dot_Phi p ni Phi ni Theta ni r ni q expr dot_Phi-p-tan(Theta)*sin(Phi)*q-tan(Theta)*cos(Phi)*r'};...
                {'dot_h ni u ni Theta ni v ni Phi ni w expr dot_h-u*sin(Theta)+(v*sin(Phi)+w*cos(Phi))*cos(Theta)'};...
                ];
            
            der = [...
                {'int dot_V dot V expr differentiator'};...
                {'int dot_a dot a expr differentiator'};...
                {'int dot_b dot b expr differentiator'};...
                {'int dot_p dot p expr differentiator'};...
                {'int dot_q dot q expr differentiator'};...
                {'int dot_r dot r expr differentiator'};...
                {'int dot_Phi dot Phi expr differentiator'};...
                {'int dot_Theta dot Theta expr differentiator'};...
                {'int dot_Psi dot Psi expr differentiator'};...
                {'int dot_h dot h expr differentiator'};...
                ];
            
            dyn = [...
                {'Xa ni V a de ni qbar par CX0 par CXa par CXde S expr -Xa+(CX0+CXa*a+CXde*de)*qbar*S'};...
                {'Ya ni V ni b ni p ni r ni da ni dr ni qbar par CY0 par CYb par CYp par CYr par CYda par CYdr par bw par S expr -Ya+(CY0+CYb*b+CYp*p*bw/2/V+CYr*r*bw/2/V+CYda*da+CYdr*dr)*qbar*S'};...
                {'Za ni V ni a ni q ni de ni qbar par CZ0 par CZa par CZq par CZde par c par S expr -Za+(CZ0+CZa*a+CZq*q*c/2/V+CZde*de)*qbar*S'};...
                {'La ni V ni b ni p ni r ni da ni dr ni qbar par Cl0 par Clb par Clp par Clr par Clda par Cldr par S par bw expr -La+(Cl0+Clb*b+Clp*p*bw/2/V*Clr*r*bw/2/V+Clda*da+Cldr*dr)*qbar*S*b'};...
                {'Ma ni V ni a ni q ni de ni qbar par Cm0 par Cma par Cmq par Cmde par S par c expr -Ma+(Cm0+Cma*a+Cmq*q*c/2/V+Cmde*de)*qbar*S*c'};...
                {'Na ni V ni b ni p ni r ni da ni dr ni qbar par Cn0 par Cnb par Cnp par Cnr par Cnda par Cndr par S par bw expr -Na+(Cn0+Cnb*b*Cnp*p*bw/2/V+Cnr*r*bw/2/V+Cnda*da+Cndr*dr)*qbar*S*b'};...
                {'Xgr Theta par m par g expr -Xgr-m*g*sin(Theta)'};...
                {'Ygr ni Theta Phi par m par g expr -Ygr+m*g*cos(Theta)*sin(Phi)'};...
                {'Zgr Theta Phi par m par g expr -Zgr+m*g*cos(Theta)*cos(Phi)'};...
                {'Fx Xa Xt Xgr expr -Fx+Xa+Xt+Xgr'};...
                {'Fy Ya Ygr expr -Fy+Ya+Ygr'};...
                {'Fz Za Zgr expr -Fz+Za+Zgr'};...
                {'L La expr -L+La'};...
                {'M Ma expr -M+Ma'};...
                {'N Na expr -N+Na'};...
                {'V u a b expr -u+V*cos(a)*cos(b)'};...
                {'ni V v b expr -v+V*sin(b)'};...
                {'ni V w a ni b expr -w+V*sin(a)*cos(b)'};...
                ];
            % Set non-zero V, u
            
            msr = [...
                {'fault Xt inp Xt_c expr -Xt+Xt_c'};...
                {'fault da inp da_c expr -da+da_c'};...
                {'fault de inp de_c expr -de+de_c'};...
                {'fault dr inp dr_c expr -dr+dr_c'};...
                {'fault V msr V_m expr -V+V_m'};...
                {'fault a msr a_m expr -a+a_m'};...
                {'fault b msr b_m expr -b+b_m'};...
                {'p msr p_m expr -p+p_m'};...
                {'q msr q_m expr -q+q_m'};...
                {'r msr r_m expr -r+r_m'};...
                {'Psi msr Psi_m expr -Psi+Psi_m'};...
                {'Theta msr Theta_m expr -Theta+Theta_m'};...
                {'Phi msr Phi_m expr -Phi+Phi_m'};...
                {'fault h msr h_m expr -h+h_m'};...
                {'fault qbar msr qbar_m expr -qbar+qbar_m'};...
                ];
            
            this.constraints = [...
                {kin},{'k'};...
                {der},{'d'};...
                {dyn},{'f'};...
                {msr},{'s'};...
                ];
            
            this.coordinates = [];
            
        end
        
    end
    
end
