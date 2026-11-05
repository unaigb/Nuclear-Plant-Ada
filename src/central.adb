--Unai García Blanco
--Jorge Caballero González
with Text_IO;

package body Central is
   protected body Reactor is
      procedure read (temp: out Integer) is
      begin
         temp := temperature;
      end read;

      procedure increase(increment:Integer) is
      begin
         temperature := temperature + increment;
      end increase;

      procedure decrease(decrement:Integer) is
      begin
         temperature := temperature - decrement;
      end decrease;

      procedure openGate is
      begin
         nextTime := lowerPeriod + Clock;
         Ada.Real_Time.Timing_Events.Set_Handler(lowerJitterControl, nextTime, Timer'Access);
      end openGate;

      procedure closeGate is
      begin
         Ada.Real_Time.Timing_Events.Set_Handler(lowerJitterControl, nextTime, NULL);
      end closeGate;

      procedure Timer(event: in out Ada.Real_Time.Timing_Events.Timing_Event) is
      begin
         temperature := temperature - 50;
         nextTime := lowerPeriod + Clock;
         -- Fin de la comprobación
         Text_IO.Put_Line("Temperatura bajada correctamente: " & temperature'Img);
         Ada.Real_Time.Timing_Events.Set_Handler(lowerJitterControl, nextTime, Timer'Access);
      end Timer;

   end Reactor;
end Central;
