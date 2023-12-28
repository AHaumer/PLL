within PLL.Examples;
model ThreephaseInverter "Three phase AC/DC inverter"
  extends Modelica.Icons.Example;
  constant Integer m=3 "Number if phases";
  parameter SI.Frequency fac=50 "AC nominal frequency";
  parameter SI.Voltage Vac=100 "AC nominal voltage rms to neutral";
  parameter SI.Frequency fRef=50 "Reference frequency";
  parameter SI.Voltage VRef=sqrt(2)*Vac*fRef/fac "Reference voltage amplitude to neutral";
  parameter SI.Voltage VMax=1/sqrt(3)*Vdc "Maximum ac voltage amplitude to neutral";
  parameter SI.Voltage Vdc=sqrt(6)*Vac "DC voltage";
  parameter SI.Frequency fsw=5e3 "Switching frequency";
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Electrical.PowerConverters.DCAC.Polyphase2Level inverter(m=m)
    annotation (Placement(transformation(extent={{-30,40},{-10,60}})));
  Modelica.Electrical.PowerConverters.DCAC.Control.SVPWM svPWM(
    f=fsw,
    startTime=0,
    uMax=VMax)
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,20})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage constantVoltage(V=Vdc)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-70,50})));
  Modelica.Blocks.Sources.Cosine cosine(amplitude=VRef, f=fRef)
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Modelica.Blocks.Sources.Sine   sine(amplitude=VRef, f=fRef)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Modelica.Electrical.Polyphase.Basic.Resistor resistor(m=m, R=fill(1e3, m))
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={20,40})));
  Modelica.Electrical.Polyphase.Basic.Star star(m=m) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={20,10})));
  Modelica.Electrical.Analog.Sensors.VoltageSensor voltageSensorNeutral
    annotation (Placement(transformation(extent={{10,-10},{-10,10}})));
  Modelica.Electrical.Polyphase.Sensors.VoltageSensor voltageSensor(m=m)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={40,40})));
  Modelica.Blocks.Math.Harmonic harmonic(f=fRef, k=1)
    annotation (Placement(transformation(extent={{70,30},{90,50}})));
  Modelica.Electrical.Machines.SpacePhasors.Blocks.ToSpacePhasor toSpacePhasor
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=270,
        origin={60,20})));
  Components.Basic3phasePLL basic3phasePLL(
    theta(fixed=true),
    A0=sqrt(2)*Vac/2,
    f0=fRef) annotation (Placement(transformation(extent={{70,-10},{90,10}})));
equation
  connect(constantVoltage.n, ground.p)
    annotation (Line(points={{-70,40},{-70,0}},    color={0,0,255}));
  connect(ground.p, inverter.dc_n) annotation (Line(points={{-70,0},{-70,30},{
          -40,30},{-40,44},{-30,44}},
                         color={0,0,255}));
  connect(constantVoltage.p, inverter.dc_p) annotation (Line(points={{-70,60},{
          -70,70},{-40,70},{-40,56},{-30,56}},
                                           color={0,0,255}));
  connect(inverter.fire_p, svPWM.fire_p)
    annotation (Line(points={{-26,38},{-26,31}}, color={255,0,255}));
  connect(inverter.fire_n, svPWM.fire_n)
    annotation (Line(points={{-14,38},{-14,31}},
                                               color={255,0,255}));
  connect(cosine.y, svPWM.u[1])
    annotation (Line(points={{-39,-20},{-19.5,-20},{-19.5,8}},
                                                             color={0,0,127}));
  connect(sine.y, svPWM.u[2]) annotation (Line(points={{-39,-50},{-20.5,-50},{
          -20.5,8}},
               color={0,0,127}));
  connect(inverter.ac, resistor.plug_p)
    annotation (Line(points={{-10,50},{20,50}}, color={0,0,255}));
  connect(resistor.plug_n, star.plug_p)
    annotation (Line(points={{20,30},{20,20}}, color={0,0,255}));
  connect(voltageSensorNeutral.p, star.pin_n)
    annotation (Line(points={{10,0},{20,0}}, color={0,0,255}));
  connect(ground.p, voltageSensorNeutral.n)
    annotation (Line(points={{-70,0},{-10,0}}, color={0,0,255}));
  connect(resistor.plug_p, voltageSensor.plug_p)
    annotation (Line(points={{20,50},{40,50}}, color={0,0,255}));
  connect(star.plug_p, voltageSensor.plug_n)
    annotation (Line(points={{20,20},{40,20},{40,30}}, color={0,0,255}));
  connect(voltageSensor.v[1], harmonic.u)
    annotation (Line(points={{51.3333,40},{68,40}}, color={0,0,127}));
  connect(voltageSensor.v, toSpacePhasor.u)
    annotation (Line(points={{51,40},{60,40},{60,32}}, color={0,0,127}));
  connect(toSpacePhasor.y, basic3phasePLL.u)
    annotation (Line(points={{60,9},{60,0},{68,0}}, color={0,0,127}));
  annotation (experiment(
      Interval=1e-05,
      Tolerance=1e-06), Documentation(info="<html>
<p>
Here the three phase PLL is tested at the output voltages of a three phase PWM inverter.
Note that there are distortions present at the outputs but keep in mind that normally 
such a PWM inverter is used with a line inductor, the voltage to synchronize with is measured at the input of the line inductor 
and this voltage contains less harmonics than the voltage directly at the input of the inverter.
</p>
</html>"));
end ThreephaseInverter;
