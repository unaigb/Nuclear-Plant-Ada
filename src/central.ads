--Unai García Blanco
--Jorge Caballero González

with Ada.Real_Time;
with Ada.Real_Time.Timing_Events;
use Ada.Real_Time;

package Central is
   protected type Reactor is
      procedure read(temp : out Integer);
      procedure increase(increment:Integer);
      procedure decrease(decrement:Integer);
      procedure openGate;
      procedure closeGate;
      procedure Timer(event: in out Ada.Real_Time.Timing_Events.Timing_Event);
   private
      temperature:Integer := 1450;
      lowerJitterControl:Ada.Real_Time.Timing_Events.Timing_Event;
      lowerPeriod:Ada.Real_Time.Time_Span:= Ada.Real_Time.Seconds(1);
      nextTime:Ada.Real_Time.Time;
   end Reactor;
end Central;
