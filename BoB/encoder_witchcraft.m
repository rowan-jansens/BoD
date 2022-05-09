function [rt] = encoder_witchcraft(data, start_index, end_index)

rt = []
for i = start_index:end_index
    dt = data.time_seconds_(i) - data.time_seconds_(i-1);
    ddl = data.encoderLeft_meters_(i) - data.encoderLeft_meters_(i-1);
    ddr = data.encoderRight_meters_(i) - data.encoderRight_meters_(i-1);
    
    vl = ddl/dt;
    vr = ddr/dt;
    
    V = (vl+vr)/2;
    Omega = (vr-vl)/diam;
    theta = theta + Omega*dt;
    rtx = V*cos(theta)*dt;
    rty = V*sin(theta)*dt;
    reconstructed_omega(end+1) = Omega;
    reconstructed_v(end+1) = V;
    reconstructed_vl(end+1) = vl;
    reconstructed_vr(end+1) = vr;
    rt(end+1,:) = rt(end,:) + [rtx rty 0];
end


