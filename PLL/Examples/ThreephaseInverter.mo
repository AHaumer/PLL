within PLL.Examples;
model ThreephaseInverter "Three phase AC/DC inverter"
  extends Modelica.Icons.Example;
  constant Integer m=3 "Number if phases";
  parameter SI.Frequency fac=50 "AC nominal frequency";
  parameter SI.Voltage Vac=100 "AC nominal voltage rms to neutral";
  parameter SI.Frequency fRef=50 "AC actual frequency";
  parameter SI.Voltage VMax=1/sqrt(3)*Vdc "Maximum ac voltage amplitude to neutral";
  parameter SI.Voltage Vdc=sqrt(6)*Vac "DC voltage";
  parameter SI.Frequency fsw=5e3 "Switching frequency";
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Modelica.Electrical.PowerConverters.DCAC.Polyphase2Level inverter(m=m)
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
  Modelica.Electrical.PowerConverters.DCAC.Control.SVPWM svPWM(
    f=fsw,
    startTime=0,
    uMax=VMax)
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,20})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage constantVoltage(V=Vdc)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-90,50})));
  Modelica.Electrical.Polyphase.Basic.Resistor resistor(m=m, R=fill(1e3, m))
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-10,40})));
  Modelica.Electrical.Polyphase.Basic.Star star(m=m) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-10,10})));
  Modelica.Electrical.Analog.Sensors.VoltageSensor voltageSensorNeutral
    annotation (Placement(transformation(extent={{-60,10},{-80,-10}})));
  Modelica.Electrical.Polyphase.Sensors.VoltageSensor voltageSensor(m=m)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={10,40})));
  Modelica.Blocks.Math.Harmonic harmonic(f=fRef, k=1)
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Modelica.Electrical.Machines.SpacePhasors.Blocks.ToSpacePhasor toSpacePhasor
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=270,
        origin={30,20})));
  Components.Basic3phasePLL basic3phasePLL(
    theta(fixed=true),
    A0=sqrt(2)*Vac/2,
    f0=fRef) annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Components.MultiVariableFilter multiVariableFilter(fN=fRef) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,-20})));
  Components.SrfPLL srfPLL(
    theta(fixed=true),
    A0=sqrt(2)*Vac/2,
    wE=2*pi*fRef)
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Modelica.Electrical.Machines.SpacePhasors.Blocks.ToSpacePhasor toSpacePhasorSource
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-40,-20})));
  Modelica.Electrical.Machines.Utilities.VfController vfController(
    VNominal=Vac,
    fNominal=fac,
    BasePhase=pi/2)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-50})));
  Modelica.Blocks.Sources.Constant const(k=fRef)
    annotation (Placement(transformation(extent={{-70,-80},{-50,-60}})));
equation
  connect(constantVoltage.n, ground.p)
    annotation (Line(points={{-90,40},{-90,0}},    color={0,0,255}));
  connect(ground.p, inverter.dc_n) annotation (Line(points={{-90,0},{-90,30},{
          -60,30},{-60,44},{-50,44}},
                         color={0,0,255}));
  connect(constantVoltage.p, inverter.dc_p) annotation (Line(points={{-90,60},{
          -90,70},{-60,70},{-60,56},{-50,56}},
                                           color={0,0,255}));
  connect(inverter.fire_p, svPWM.fire_p)
    annotation (Line(points={{-46,38},{-46,31}}, color={255,0,255}));
  connect(inverter.fire_n, svPWM.fire_n)
    annotation (Line(points={{-34,38},{-34,31}},
                                               color={255,0,255}));
  connect(inverter.ac, resistor.plug_p)
    annotation (Line(points={{-30,50},{-10,50}},color={0,0,255}));
  connect(resistor.plug_n, star.plug_p)
    annotation (Line(points={{-10,30},{-10,20}},
                                               color={0,0,255}));
  connect(voltageSensorNeutral.p, star.pin_n)
    annotation (Line(points={{-60,0},{-10,0}},
                                             color={0,0,255}));
  connect(ground.p, voltageSensorNeutral.n)
    annotation (Line(points={{-90,0},{-80,0}}, color={0,0,255}));
  connect(resistor.plug_p, voltageSensor.plug_p)
    annotation (Line(points={{-10,50},{10,50}},color={0,0,255}));
  connect(star.plug_p, voltageSensor.plug_n)
    annotation (Line(points={{-10,20},{10,20},{10,30}},color={0,0,255}));
  connect(voltageSensor.v[1], harmonic.u)
    annotation (Line(points={{21.3333,40},{38,40}}, color={0,0,127}));
  connect(voltageSensor.v, toSpacePhasor.u)
    annotation (Line(points={{21,40},{30,40},{30,32}}, color={0,0,127}));
  connect(toSpacePhasor.y, basic3phasePLL.u)
    annotation (Line(points={{30,9},{30,0},{38,0}}, color={0,0,127}));
  connect(toSpacePhasor.y, multiVariableFilter.u)
    annotation (Line(points={{30,9},{30,-8}}, color={0,0,127}));
  connect(multiVariableFilter.y, srfPLL.u)
    annotation (Line(points={{30,-31},{30,-40},{38,-40}}, color={0,0,127}));
  connect(svPWM.u, toSpacePhasorSource.y)
    annotation (Line(points={{-40,8},{-40,-9}}, color={0,0,127}));
  connect(toSpacePhasorSource.u, vfController.y)
    annotation (Line(points={{-40,-32},{-40,-39}}, color={0,0,127}));
  connect(const.y, vfController.u)
    annotation (Line(points={{-49,-70},{-40,-70},{-40,-62}}, color={0,0,127}));
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
