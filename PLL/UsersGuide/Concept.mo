within PLL.UsersGuide;
class Concept "Concept"
  extends Modelica.Icons.Information;
  annotation (preferredView="info",Documentation(info="<html>
<p>
The phase locked loops (PLL) demonstrated in this library are intended to be used in power electronic inverters to synchronize with grid voltage, 
such as feeding power from solar panels, windmills or electrical energy storages like batteries to the grid, but also active line modules of frequency inverters for electric drives. 
Another application is the determination of rotor angle of a permanent magnet excited synchronous machine using a sin-cos-resolver. 
Problems arise when the grid voltage - either single phase or three phase - is distorted or imbalanced. 
The PLLs are based on the publications of <a href=\"modelica://PLL.UsersGuide.References\">Masoud Karimi-Ghartemani</a> with some modifications described as follows.
</p>
<p>
In this library the representation of signals (i.e. AC voltages) is based on cosine: <code>u(t) = &ucirc;&sdot;cos(2&pi;f&sdot;t + &phi;)</code> 
where &phi; is the angle measured from the maximum of the cosine function to the origin.
</p>
<p>
Threephase voltages with positive sequence are defined as:<br>
<code>u<sub>1</sub>(t) = &ucirc;&sdot;cos(2&pi;f&sdot;t + &phi; - 0/3&sdot;&pi;)</code><br>
<code>u<sub>2</sub>(t) = &ucirc;&sdot;cos(2&pi;f&sdot;t + &phi; - 2/3&sdot;&pi;)</code><br>
<code>u<sub>3</sub>(t) = &ucirc;&sdot;cos(2&pi;f&sdot;t + &phi; - 4/3&sdot;&pi;)</code>
</p>
<p>
The Clarke - Parke - Transformation results in a space phasor <code><u>u</u> = u<sub>d</sub> + j&sdot;u<sub>q</sub></code>, 
i.e. the real axis is aligned with the d-axis.<br>
To perform the Park - Transformation, the phasor has to be rotated by the angle &thetasym; measured from &alpha;-axis to d-axis:<br>
<code>u<sub>d</sub> + j&sdot;u<sub>q</sub> = (u<sub>&alpha;</sub> + j&sdot;u<sub>&beta;</sub>)&sdot;e<sup>-j&thetasym;</sup></code>
</p>
</html>"));
end Concept;
