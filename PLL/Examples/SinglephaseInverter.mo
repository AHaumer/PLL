within PLL.Examples;
model SinglephaseInverter "Single phase AC/DC inverter"
  extends Modelica.Icons.Example;
  parameter SI.Voltage Vac=100 "AC voltage rms";
  parameter SI.Frequency fRef=50 "Reference frequency";
  parameter SI.Voltage Vdc=2/pi*sqrt(2)*Vac "DC voltage";
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
  PowerElectronics.HBridge inverter
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  PowerElectronics.BipolarPWM bipolarPWM(fsw=1e3, constantVdc=Vdc) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,20})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage constantVoltage(V=Vdc)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-60,50})));
  Modelica.Electrical.Analog.Sensors.VoltageSensor voltageSensor annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={30,50})));
  Modelica.Blocks.Math.Harmonic harmonic(f=fRef, k=1)
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Modelica.Blocks.Sources.Cosine cosine(amplitude=sqrt(2)*Vac/2, f=fRef)
    annotation (Placement(transformation(extent={{-50,-20},{-30,0}})));
  Components.Enhanced1phasePLL enhanced1phasePLL(A0=sqrt(2)*Vac/2, f0=fRef,
    lamda=10,
    phi(fixed=true))
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
equation
  connect(inverter.fire_p, bipolarPWM.fireL)
    annotation (Line(points={{-16,38},{-16,31}}, color={255,0,255}));
  connect(inverter.fire_n, bipolarPWM.fireR)
    annotation (Line(points={{-4,38},{-4,31}}, color={255,0,255}));
  connect(constantVoltage.n, ground.p)
    annotation (Line(points={{-60,40},{-60,30}},   color={0,0,255}));
  connect(ground.p, inverter.dc_n1) annotation (Line(points={{-60,30},{-30,30},
          {-30,44},{-20,44}}, color={0,0,255}));
  connect(constantVoltage.p, inverter.dc_p1) annotation (Line(points={{-60,60},
          {-60,70},{-30,70},{-30,56},{-20,56}},
                                             color={0,0,255}));
  connect(inverter.dc_p2, voltageSensor.p) annotation (Line(points={{0,56},{10,
          56},{10,60},{30,60}}, color={0,0,255}));
  connect(inverter.dc_n2, voltageSensor.n) annotation (Line(points={{0,44},{10,
          44},{10,40},{30,40}}, color={0,0,255}));
  connect(voltageSensor.v, harmonic.u)
    annotation (Line(points={{41,50},{58,50}}, color={0,0,127}));
  connect(cosine.y, bipolarPWM.vRef)
    annotation (Line(points={{-29,-10},{-10,-10},{-10,8}}, color={0,0,127}));
  connect(voltageSensor.v, enhanced1phasePLL.u) annotation (Line(points={{41,50},
          {50,50},{50,10},{58,10}}, color={0,0,127}));
  annotation (experiment(
      Interval=1e-05,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"), Documentation(info="<html>
<p>
Here the enhance single phase PLL ist tested at the output voltages of a single phase PWM inverter.
Note that there are distotions present at the outputs but keep in mind that normally 
such a PWM inverter is used with a line inductor, the voltage to synchronize with is measured at the input of the line inductor 
and this voltage contains less harmonics than the voltage directly at the input of the H-bridge.
</p>
</html>"));
end SinglephaseInverter;
