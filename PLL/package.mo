within ;
package PLL "Phase Locked Loops for inverter applications"
  import Modelica.Units.SI;
  import Modelica.Constants.pi;
  import Modelica.Electrical.Polyphase.Functions.symmetricOrientation;

  annotation (preferredView="info",
    version="1.1.0", versionDate="2025-04-19", uses(Modelica(version="4.0.0")),
    Documentation(info="<html>
<p>
This is a library dealing with phase locked loop algorithms for power applications based mainly on the publications of Masoud Karimi-Ghartemani.
</p>
<p>
&copy; 2025 <a href=\\\"mailto:anton.haumer@oth-regensburg.de\\\">Anton.Haumer@OTH-Regensburg.de</a>
</p>
</html>"));
end PLL;
