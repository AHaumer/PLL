within PLL.Examples;
model SinglephaseInverter "Single phase AC/DC inverter"
  extends Modelica.Icons.Example;
  parameter SI.Frequency fac=50 "AC nominal frequency";
  parameter SI.Voltage Vac=100 "AC nominal voltage rms";
  parameter SI.Frequency fRef=50 "Reference frequency";
  parameter SI.Voltage Vdc=2/pi*sqrt(2)*Vac "DC voltage";
  parameter SI.Frequency fsw=5e3 "Switching frequency";
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  PowerElectronics.HBridge inverter
    annotation (Placement(transformation(extent={{-30,40},{-10,60}})));
  PowerElectronics.BipolarPWM bipolarPWM(fsw=fsw, constantVdc=Vdc) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,20})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage constantVoltage(V=Vdc)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-70,50})));
  Modelica.Electrical.Analog.Sensors.VoltageSensor voltageSensor annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={20,50})));
  Modelica.Blocks.Math.Harmonic harmonic(f=fRef, k=1)
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Components.Enhanced1phasePLL enhanced1phasePLL(
    theta(fixed=true),                           A0=sqrt(2)*Vac/2, f0=fRef,
    lamda=10)
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Modelica.Electrical.Machines.Utilities.VfController vfController(
    VNominal=Vac,
    fNominal=fac,
    BasePhase=pi/2)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,-10})));
  Modelica.Blocks.Sources.Constant const(k=fRef)
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));
equation
  connect(inverter.fire_p, bipolarPWM.fireL)
    annotation (Line(points={{-26,38},{-26,31}}, color={255,0,255}));
  connect(inverter.fire_n, bipolarPWM.fireR)
    annotation (Line(points={{-14,38},{-14,31}},
                                               color={255,0,255}));
  connect(constantVoltage.n, ground.p)
    annotation (Line(points={{-70,40},{-70,0}},    color={0,0,255}));
  connect(ground.p, inverter.dc_n1) annotation (Line(points={{-70,0},{-70,30},{
          -40,30},{-40,44},{-30,44}},
                              color={0,0,255}));
  connect(constantVoltage.p, inverter.dc_p1) annotation (Line(points={{-70,60},
          {-70,70},{-40,70},{-40,56},{-30,56}},
                                             color={0,0,255}));
  connect(inverter.dc_p2, voltageSensor.p) annotation (Line(points={{-10,56},{0,
          56},{0,60},{20,60}},  color={0,0,255}));
  connect(inverter.dc_n2, voltageSensor.n) annotation (Line(points={{-10,44},{0,
          44},{0,40},{20,40}},  color={0,0,255}));
  connect(voltageSensor.v, harmonic.u)
    annotation (Line(points={{31,50},{58,50}}, color={0,0,127}));
  connect(voltageSensor.v, enhanced1phasePLL.u) annotation (Line(points={{31,50},
          {40,50},{40,10},{58,10}}, color={0,0,127}));
  connect(vfController.y[1], bipolarPWM.vRef)
    annotation (Line(points={{-20,1},{-20,8}}, color={0,0,127}));
  connect(const.y, vfController.u)
    annotation (Line(points={{-29,-30},{-20,-30},{-20,-22}}, color={0,0,127}));
  annotation (experiment(
      Interval=1e-05,
      Tolerance=1e-06), Documentation(info="<html>
<p>
Here the enhance single phase PLL is tested at the output voltages of a single phase PWM inverter.
Note that there are distortions present at the outputs but keep in mind that normally 
such a PWM inverter is used with a line inductor, the voltage to synchronize with is measured at the input of the line inductor 
and this voltage contains less harmonics than the voltage directly at the input of the H-bridge.
</p>
</html>"));
end SinglephaseInverter;
