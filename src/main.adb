--Unai García Blanco
--Jorge Caballero González

with Central;
with Text_IO;
use Central;
with Ada.Calendar;
with Ada.Numerics;
with Ada.Real_Time;
with Ada.Numerics.Discrete_Random;
use Ada.Calendar;

procedure Main is
   type Reactors is array (1..3) of aliased Reactor;
   subtype RandomReactor is Integer range 1..3;
   package Random is new Ada.Numerics.Discrete_Random(RandomReactor);

   --Tarea del aumento de la temperatura
   task type Temperature( r: access Reactors);
   task body Temperature is
      interval:Duration := 2.0;
      nextTime:Time;
      seed:Random.Generator;
      temp:RandomReactor;
   begin
      Random.Reset(seed);
      nextTime := Clock + interval;
      loop
         -- Se aumenta la temperatura de manera aleatoria
         temp := Random.Random(seed);
         r(temp).increase(150);
         -- Fin de la comprobación
         Text_IO.Put_Line("Se incrementará la temperatura del reactor: " & temp'Img);
         delay until nextTime;
         nextTime := Clock + interval;
      end loop;
   end Temperature;
   -- Tarea de los sensores
   task type Sensor(r: access Reactor) is
      entry read(result: out Integer);
   end Sensor;
   task body Sensor is
      interval:Duration := 1.0;
      nextTime:Time;
   begin
      loop
         select
            accept read(result: out Integer) do
               nextTime := interval + Clock;
               r.read(result);
               delay until nextTime;
            end read;
         or
            terminate;
         end select;
      end loop;
   end Sensor;

   -- Tarea del Actuador
   task type Actuator(r: access Reactor; id: Integer) is
      entry open;
      entry close;
   end Actuator;
   task body Actuator is
      moveIntervalGate:Duration := 0.1;
      moveTimer:Time;
      closed:Boolean := true;
   begin
      loop
         select
            accept open do
               begin
                  if closed = true then
                     -- Fin de la comprobación
                     Text_IO.Put_Line("Abriendo la compuerta del reactor: " & id'Img);
               	     moveTimer := Clock + moveIntervalGate;
                     delay until moveTimer;
                     r.openGate;
                     Text_IO.Put_Line("Abierta la compuerta del reactor: " & id'Img);
                     closed := false;
                  end if;
               end;
            end open;
         or
            accept close do
               begin
                  if closed = false then
                     Text_IO.Put_Line("Cerrando la compuerta del reactor: " & id'Img);
                     moveTimer := Clock + moveIntervalGate;
                     delay until moveTimer;
                     r.closeGate;
                     Text_IO.Put_Line("Cerrada la compuerta del reactor: " & id'Img);
                     closed := true;
                  end if;
               end;
            end close;
         or
            terminate;
         end select;
      end loop;
   end Actuator;

   -- Tarea de la Coordinadora de Reactores
   task type Controller is
      entry warning;
   end Controller;
   task body Controller is
   begin
      loop
         select
            accept warning do
               begin
                  null;
               end;
            end warning;
         or delay 3.0;
            Text_IO.Put_Line("¡¡¡¡ATENCIÓN, ALARMA!!!!");
         end select;
      end loop;
   end Controller;

   -- Tarea de la función del reactor
   task type reactorTask (r: access Reactor; id: Integer) is
      private
   end reactorTask;
   task body reactorTask is
      sen:Sensor(r);
      act:Actuator(r, id);
      con:Controller;
      interval:Duration := 2.0;
      nextTimer:Time;
      initialInterval:Duration := 0.5;
      beginning:Time;
      temperature:Integer;
   begin
      beginning := initialInterval + Clock;
      delay until beginning;
      nextTimer := interval + Clock;
      loop
         sen.read(temperature);
         -- Fin de la comprobación
         Text_IO.Put_Line("Temperatura: " & temperature'Img & " Reactor: " & id'Img);
         if temperature >= 1500 then
            act.open;
            if temperature > 1750 then
               Text_IO.Put_Line("¡¡¡ALERTA, TEMPERATURA MUY ALTA!!! " & temperature'Img & " Reactor: " & id'Img);
            end if;
         elsif temperature < 1500 then
            act.close;
         end if;
         con.warning;
         delay until nextTimer;
         nextTimer := interval + Clock;
      end loop;
   end;

   -- Procedimiento de lanzar las tareas
   procedure beginning is
      rs : aliased Reactors;
      t : Temperature(rs'Access);
      r1 : reactorTask(rs(1)'Access, 1);
      r2 : reactorTask(rs(2)'Access, 2);
      r3 : reactorTask(rs(3)'Access, 3);
   begin
      null;
   end;
begin
   beginning;
end Main;
