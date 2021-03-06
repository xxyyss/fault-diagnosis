classdef g033 < model
    
    methods
        function this = g033()
            this.name = 'g033';
            this.description = 'Ardupilot MAVLink model';
            
            %% Equation list
            % legend:
            % dot - differential relation
            % int - integral term
            % trig - trigonometric term
            % ni - general non-invertible term
            % inp - input variable
            % out - output variable % NOT SUPPORTED
            % msr - measured variable
            % sub - subsystem where the equation belongs
            kin = [...
                {'climb v_d expr -climb-v_d'};...
                {'v_ground ni v_n ni v_e expr -v_ground+sqrt(v_n^2+v_e^2)'};...
                {'dot_p_n v_n expr equal'};...
                {'dot_p_e v_e expr equal'};...
                {'dot_p_d v_d expr equal'};...
                {'v_w_n ni dir_wind ni v_wind_hor expr -v_w_n+v_wind_hor*cos(dir_wind)'};...
                {'v_w_e ni dir_wind ni v_wind_hor expr -v_w_e+v_wind_hor*sin(dir_wind)'};...
                {'ni cog ni v_e ni v_n expr -tan(cog)+v_e/v_n'};...
                {'v_air press_diff par rho expr -press_diff+0.5*rho*v_air*v_air'};...
                {'v_air ni v_ground ni v_wind_hor ni cog ni dir_wind expr -v_air+sqrt(v_ground^2+v_wind_hor^2-2*v_ground*v_wind_hor*cos(dir_wind-cog))'};...
                % Write something like alt_agl-alt0 = -p_d
                ];
            
            % Limits on variables
            lim = [...
                {'ni load par load_max expr max(load-load_max,0)'};...
                {'ni voltage_battery par voltage_battery_min expr max(voltage_battery_min-voltage_battery,0)'};...
                {'ni current_battery par current_battery_max expr max(current_battery-current_battery_max,0)'};...
                {'ni drop_rate_comm par drop_rate_comm_max expr max(drop_rate_comm-drop_rate_comm_max,0)'};...
                {'ni gps_fix_type par gps_fix_type_min expr max(gps_fix_type_min-gps_fix_type,0)'};...
                {'ni eph par eph_min expr max(eph_min-eph,0)'};...
                {'ni epv par epv_min expr max(epv_min-epv,0)'};...
                {'ni satellites par satellites_min expr max(satellites_min-satellites,0)'};...
                {'ni alt_agl par alt_agl_min expr max(alt_agl_min-alt_agl,0)'};...
                {'ni vcc par vcc_min par vcc_max expr max(max(vcc_min-vcc,0),max(vcc-vcc_max,0))'};...
                {'ni v_servo par v_servo_min par v_servo_max expr max(max(v_servo_min-v_servo,0),max(v_servo-v_servo_max,0))'};...
                {'ni freemem par freemem_min expr max(freemem_min-freemem,0)'};...
                {'ni ratio_v_air par ratio_v_air_min par ratio_v_air_max expr max(max(ratio_v_air_min-ratio_v_air,0),max(ratio_v_air-ratio_v_air_max,0))'};...
                {'ni vibration_x par vibration_x_max expr max(vibration_x-vibration_x_max,0)'};...
                {'ni vibration_y par vibration_y_max expr max(vibration_y-vibration_y_max,0)'};...
                {'ni vibration_z par vibration_z_max expr max(vibration_z-vibration_z_max,0)'};...
                {'ni temperature par temperature_min par temperature_max expr max(max(temperature_min-temperature,0),max(temperature-temperature_max,0))'};...
                {'ni v_air par v_air_min expr max(v_air_min-v_air,0)'};...
                {'ni error_v_air par error_v_air_min par error_v_air_max expr max(max(error_v_air_min-error_v_air,0),max(error_v_air-error_v_air_max,0))'};...
                ];
            
            der = [...
                {'int dot_p_n dot p_n expr differentiator'};...
                {'int dot_p_e dot p_e expr differentiator'};...
                {'int dot_p_d dot p_d expr differentiator'};...
                ];
            
            dyn = [...
                ];
            
            mod = [...
                {'par h_total ni h_x ni h_y ni h_z expr -h_total+sqrt(h_x^2+h_y^2+h_z^2)'};...
            % Add something about the atmosphere model?
                ];
            
            % Equality constraints
            equ = [...
                {'roll_c roll expr equal'};...
                {'pitch_c pitch expr equal'};...
                {'ni yaw_c ni yaw expr equal'};...  % Wrap the error within [-pi,pi)
                {'ni error_alt expr error_alt'};...
                {'ni error_v_air expr error_v_air'};...
                {'ni error_xtrack expr error_xtrack'};...
                {'ni error_rp_dcm expr error_rp_dcm'};...
                {'ni error_yaw_dcm expr error_yaw_dcm'};...                
                ];
            
%             % Add all MAVLink messages info
%             msg_id, msg_name
            msr = [...
%             0, HEARTBEAT
%             1, SYS_STATUS
                {'fault msr load_sys_status load sub autopilot expr -load_sys_status/10+load'};...
                {'fault msr voltage_battery_sys_status voltage_battery sub autopilot expr -voltage_battery_sys_status/1000+voltage_battery'};...
                {'fault msr current_battery_sys_status current_battery sub autopilot expr -current_battery_sys_status/100+current_battery'};...
                {'fault msr drop_rate_comm_sys_status drop_rate_comm sub autopilot expr -drop_rate_comm_sys_status/100+drop_rate_comm'};...
%                 {''};...
%             2, SYSTEM_TIME
%             24, GPS_RAW_INT
                {'fault msr fix_type_gps_raw_int gps_fix_type sub sensors expr equal'};...
                {'fault msr lat_gps_raw_int latitude sub sensors expr -lat_gps_raw_int/1e7+latitude'};...
                {'fault msr lon_gps_raw_int longitude sub sensors expr -lon_gps_raw_int/1e7+longitude'};...
                {'fault msr alt_gps_raw_int alt_msl sub sensors expr -alt_gps_raw_int/1000+alt_msl'};...
                {'fault msr eph_gps_raw_int eph sub sensors expr equal'};...
                {'fault msr epv_gps_raw_int epv sub sensors expr equal'};...
                {'fault msr vel_gps_raw_int v_ground sub sensors expr -vel_gps_raw_int/100+v_ground'};...
                {'fault msr cog_gps_raw_int cog sub sensors expr -cog_gps_raw_int/100*pi/180+cog'};...
                {'fault msr satellites_visible_gps_raw_int satellites sub sensors expr equal'};...
%             25, GPS_STATUS
%             26, SCALED_IMU
%             27, RAW_IMU % This is problematic because it depends on which
%             IMU is active
%                 {'msr a_x_raw_imu a_x'};...
%                 {'msr a_y_raw_imu a_y'};...
%                 {'msr a_z_raw_imu a_z'};...
%                 {'msr p_raw_imu p'};...
%                 {'msr q_raw_imu q'};...
%                 {'msr r_raw_imu r'};...
%                 {'msr h_x_raw_imu h_x'};...
%                 {'msr h_y_raw_imu h_y'};...
%                 {'msr h_z_raw_imu h_z'};...
%             28, RAW_PRESSURE
%             29, SCALED_PRESSURE
                {'fault msr press_abs_scaled_pressure press_abs sub sensors expr -press_abs_scaled_pressure/100+press_abs'};...
                {'fault msr press_diff_scaled_pressure press_diff sub sensors expr -press_diff_scaled_pressure/100+press_diff'};...
                {'fault msr temperature_scaled_pressure temperature sub sensors expr -temperature_scaled_pressure/100+temperature'};...
%             30, ATTITUDE
                {'fault msr roll_attitude roll sub navigation expr equal'};...
                {'fault msr pitch_attitude pitch sub navigation expr equal'};...
                {'fault msr yaw_attitude yaw sub navigation expr equal'};...
                {'fault msr rollspeed_attitude p sub navigation expr equal'};...
                {'fault msr pitchspeed_attitude q sub navigation expr equal'};...
                {'fault msr yawspeed_attitude r sub navigation expr equal'};...
%             31, ATTITUDE_QUATERNION
%             32, LOCAL_POSITION_NED
                {'fault msr x_local_position_ned p_n sub navigation expr equal'};...
                {'fault msr y_local_position_ned p_e sub navigation expr equal'};...
                {'fault msr z_local_position_ned p_d sub navigation expr equal'};...
                {'fault msr vx_local_position_ned v_n sub navigation expr equal'};...
                {'fault msr vy_local_position_ned v_e sub navigation expr equal'};...
                {'fault msr vz_local_position_ned v_d sub navigation expr equal'};...
%             33, GLOBAL_POSITION_INT
                {'fault msr lat_global_position_int latitude sub navigation expr -lat_global_position_int/1e7+latitude'};...
                {'fault msr lon_global_position_int longitude sub navigation expr -lon_global_position_int/1e7+longitude'};...
                {'fault msr alt_global_position_int alt_msl sub navigation expr -alt_global_position_int/1000+alt_msl'};...
                {'fault msr relative_alt_global_position_int alt_agl sub navigation expr -relative_alt_global_position_int/1000+alt_agl'};...
                {'fault msr vx_global_position_int v_n sub navigation expr -vx_global_position_int/100+v_n'};...
                {'fault msr vy_global_position_int v_e sub navigation expr -vy_global_position_int/100+v_e'};...
                {'fault msr vz_global_position_int v_d sub navigation expr -vz_global_position_int/100-v_d'};...
                {'fault msr hdg_global_position_int yaw sub navigation expr -hdg_global_position_int/100*pi/180+yaw'};...
%             34, RC_CHANNELS_SCALED
%             35, RC_CHANNELS_RAW
%                 {''};...
%             36, SERVO_OUTPUT_RAW
%                 {''};...
%             49, GPS_GLOBAL_ORIGIN
%             61, ATTITUDE_QUATERNION_COV
%             62, NAV_CONTROLLER_OUTPUT
                {'fault msr nav_roll_nav_controller_output roll_c sub autopilot expr -nav_roll_nav_controller_output*pi/180+roll_c'};...
                {'fault msr nav_pitch_nav_controller_output pitch_c sub autopilot expr -nav_pitch_nav_controller_output*pi/180+pitch_c'};...
                {'fault msr nav_bearing_nav_controller_output yaw_c sub autopilot expr -nav_bearing_nav_controller_output*pi/180+yaw_c'};...
%                 {'msr bearing_target_nav_controller_output bearing_target sub autopilot expr equal'};...
%                 {'msr dist_wp_nav_controller_output dist_wp sub autopilot expr equal'};...
                {'fault msr alt_error_nav_controller_output error_alt sub autopilot expr equal'};...
                {'fault msr aspd_error_nav_controller_output error_v_air sub autopilot expr -aspd_error_nav_controller_output/100+error_v_air'};...
                {'fault msr xtrack_error_nav_controller_output error_xtrack sub autopilot expr equal'};...
%             63, GLOBAL_POSITION_INT_COV
%             64, LOCAL_POSITION_NED_COV
%             65, RC_CHANNELS
%                 {''};...
%             74, VFR_HUD
                {'fault msr airspeed_vfr_hud v_air sub navigation expr equal'};...
                {'fault msr groundspeed_vfr_hud v_ground sub navigation expr equal'};...
                {'fault msr heading_vfr_hud yaw sub navigation expr -heading_vfr_hud*pi/180+yaw'};...
                {'fault msr throttle_vfr_hud throttle_out sub navigation expr equal'};...
                {'fault msr alt_vfr_hud alt_msl sub navigation expr equal'};...
                {'fault msr climb_vfr_hud climb sub navigation expr equal'};...
%             100, OPTICAL_FLOW
%             101, GLOBAL_VISION_POSITION_ESTIMATE
%             102, VISION_POSITION_ESTIMATE
%             103, VISION_SPEED_ESTIMATE
%             104, VICON_POSITION_ESTIMATE
%             105, HIGHRES_IMU
%             106, OPTICAL_FLOW_RAD
%             111, TIMESYNC
%             116, SCALED_IMU2
                {'fault msr xacc_scaled_imu2 a_x_m par g sub sensors expr -xacc_scaled_imu2/1000*g+a_x_m'};...
                {'fault msr yacc_scaled_imu2 a_y_m par g sub sensors expr -yacc_scaled_imu2/1000*g+a_y_m'};...
                {'fault msr zacc_scaled_imu2 a_z_m par g sub sensors expr -zacc_scaled_imu2/1000*g+a_z_m'};...
                {'fault msr xgyro_scaled_imu2 p sub sensors expr -xgyro_scaled_imu2/1000+p'};...
                {'fault msr ygyro_scaled_imu2 q sub sensors expr -ygyro_scaled_imu2/1000+q'};...
                {'fault msr zgyro_scaled_imu2 r sub sensors expr -zgyro_scaled_imu2/1000+r'};...
                {'fault msr xmag_scaled_imu2 h_x sub sensors expr -xmag_scaled_imu2/1000+h_x'};...
                {'fault msr ymag_scaled_imu2 h_y sub sensors expr -ymag_scaled_imu2/1000+h_y'};...
                {'fault msr zmag_scaled_imu2 h_z sub sensors expr -zmag_scaled_imu2/1000+h_z'};...
%             124, GPS2_RAW
%             125, POWER_STATUS
                {'fault msr vcc_power_status vcc sub sensors expr -vcc_power_status/1000+vcc'};...
                {'fault msr vservo_power_status v_servo sub sensors expr -vservo_power_status/1000+v_servo'};...
%                 {'msr flags'};...
%             127, GPS_RTK
%             128, GPS2_RTK
%             129, SCALED_IMU3
%             132, DISTANCE_SENSOR
%             137, SCALED_PRESSURE2
%             138, ATT_POS_MOCAP
%             141, ALTITUDE
%             143, SCALED_PRESSURE3
%             146, CONTROL_SYSTEM_STATE
%             147, BATTERY_STATUS
%             150, SENSOR_OFFSETS % This is problematic because it depends on which
%             IMU, barometer and INS is active
%                 {''};...
%             152, MEMINFO
                {'fault msr freemem_meminfo freemem sub os expr equal'};...
%             153, AP_ADC
%             163, AHRS
                {'fault msr error_rp_ahrs error_rp_dcm sub navigation expr equal'};...
                {'fault msr error_yaw_ahrs error_yaw_dcm sub navigation expr equal'};...
%             165, HWSTATUS
                {'fault msr vcc_hwstatus vcc sub autopilot expr -vcc_hwstatus/1000+vcc'};...
%             167, LIMITS_STATUS
%             168, WIND
                {'fault msr direction_wind dir_wind sub navigation expr -direction_wind*pi/180+dir_wind'};...
                {'fault msr speed_wind v_wind_hor sub navigation expr equal'};...
                {'fault msr speed_z_wind v_wind_vert sub navigation expr equal'};...
%             173, RANGEFINDER
%             174, AIRSPEED_AUTOCAL
                {'fault msr ratio_airspeed_autocal ratio_v_air sub autopilot expr equal'};...
%             178, AHRS2
                {'fault msr roll_ahrs2 roll sub navigation expr equal'};...
                {'fault msr pitch_ahrs2 pitch sub navigation expr equal'};...
                {'fault msr yaw_ahrs2 yaw sub navigation expr equal'};...
%                 {'fault msr altitude_ahrs2 alt_msl sub navigation expr equal'};... % This field is not populated
%                 {'fault msr lat_ahrs2 latitude sub navigation expr equal'};...  % This field is not populated
%                 {'fault msr lng_ahrs2 longitude sub navigation expr equal'};... % This field is not populated
%             181, BATTERY2
%             182, AHRS3
                {'fault msr roll_ahrs3 roll sub navigation expr equal'};...
                {'fault msr pitch_ahrs3 pitch sub navigation expr equal'};...
                {'fault msr yaw_ahrs3 yaw sub navigation expr equal'};...
                {'fault msr altitude_ahrs3 alt_msl sub navigation expr equal'};...
                {'fault msr lat_ahrs3 latitude sub navigation expr -lat_ahrs3/1e7+latitude'};...
                {'fault msr lng_ahrs3 longitude sub navigation expr -lng_ahrs3/1e7+longitude'};... 
%             191, MAG_CAL_PROGRESS
%             192, MAG_CAL_REPORT
%             193, EKF_STATUS_REPORT % This is problematic because it depends on which
%             AHRS is active
%                 {''};...
%             194, PID_TUNING
%             226, RPM
%             230, ESTIMATOR_STATUS
%             231, WIND_COV
%             232, GPS_INPUT
%             234, HIGH_LATENCY
%             241, VIBRATION
                {'fault msr vibration_x_vibration vibration_x sub sensors expr equal'};...
                {'fault msr vibration_y_vibration vibration_y sub sensors expr equal'};...
                {'fault msr vibration_z_vibration vibration_z sub sensors expr equal'};...
%             246, ADSB_VEHICLE
%             247, COLLISION
                ];
            
            this.constraints = [...
                {kin},{'k'};...
                {lim},{'l'};...
                {der},{'d'};...
                {dyn},{'f'};...
                {mod},{'m'};...
                {equ},{'e'};...
                {msr},{'s'};...
                ];            
        end
        
    end
    
end