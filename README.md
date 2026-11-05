<div align="center">

# ☢️ Central Nuclear en Ada

**Simulación concurrente de una central con tres reactores usando tareas, objetos protegidos y eventos temporizados**

[![Ada](https://img.shields.io/badge/Ada-2012-02f88c?style=flat&logoColor=white)]()
[![GNAT](https://img.shields.io/badge/GNAT-gprbuild-1F7A8C?style=flat)]()
[![Concurrencia](https://img.shields.io/badge/Concurrencia-tareas_y_objetos_protegidos-0F172A?style=flat)]()

[Descripción](#-sobre-el-proyecto) · [Cómo funciona](#-cómo-funciona) · [Cómo ejecutarlo](#-cómo-ejecutarlo) · [Estructura](#-estructura-del-repositorio) · [Stack](#-stack-tecnológico)

</div>

---

## 📖 Sobre el proyecto

Una central nuclear con **tres reactores** cuya temperatura sube sin avisar. Un sistema de **sensores, actuadores y un controlador** tiene que vigilarla y reaccionar a tiempo: abrir la compuerta de refrigeración cuando hace falta, cerrarla cuando ya no, y dar la alarma si la temperatura se dispara.

El objetivo es practicar la **programación concurrente y de tiempo real en Ada**: tareas que corren a la vez, comunicación entre ellas y acceso seguro a datos compartidos.

> 📌 **Proyecto académico** desarrollado para la asignatura de *Programación Avanzada* (Universidad de Salamanca), en pareja con Jorge Caballero González.

---

## ⚙️ Cómo funciona

El estado de cada reactor vive en un **tipo protegido** (`Reactor`), que garantiza el acceso exclusivo a la temperatura (inicial: 1450). Cada reactor tiene su propia tarea de control, y esta crea a su vez un sensor, un actuador y un controlador exclusivos. Las tareas son:

| Tarea | Qué hace |
| :--- | :--- |
| **`Temperature`** | Cada 2 s elige un reactor al azar y le sube **150** grados. |
| **`Sensor`** | Lee la temperatura de un reactor cada segundo; responde a una petición `read` mediante una cita (*rendezvous*). |
| **`reactorTask`** | Una por reactor. Cada 2 s lee la temperatura y decide: **≥ 1500** abre la compuerta, **> 1750** lanza una alerta de temperatura muy alta, **< 1500** la cierra. |
| **`Actuator`** | Abre y cierra la compuerta de su reactor (el movimiento tarda 0,1 s). |
| **`Controller`** | Hace de **vigilante** (*watchdog*): `reactorTask` le avisa en cada ciclo y, si pasan **3 s** sin aviso, activa la **alarma**. |

Mientras la compuerta está abierta, un **evento temporizado** (`Timing_Events`) se repite cada segundo y **baja la temperatura 50 grados**; al cerrarla, el evento se cancela.

Conceptos de Ada que se usan: `protected type`, `task type` con `entry`, `select` con `terminate` y `delay`, `delay until` para periodos exactos, y `Ada.Real_Time.Timing_Events`.

---

## 🚀 Cómo ejecutarlo

**Requisitos:** un compilador **GNAT** (por ejemplo, GNAT Community o el de tu distribución) con `gprbuild`.

```bash
gprbuild -P tareas.gpr
./obj/main        # en Windows: obj\main.exe
```

La consola muestra cómo sube y baja la temperatura de cada reactor, la apertura y cierre de compuertas y las alertas. La simulación no termina sola: se detiene con `Ctrl + C`.

---

## 📂 Estructura del repositorio

```
Nuclear-Plant-Ada/
├── src/
│   ├── central.ads   # Especificación del tipo protegido Reactor
│   ├── central.adb   # Cuerpo: lectura, subida/bajada, compuerta y evento temporizado
│   └── main.adb      # Tareas: temperatura, sensor, actuador, controlador y reactores
└── tareas.gpr        # Proyecto de GNAT
```

---

## 🖥️ Stack tecnológico

| Categoría | Herramientas |
| :--- | :--- |
| **Lenguaje** | Ada |
| **Concurrencia** | Tareas · tipos protegidos · citas (*rendezvous*) · eventos temporizados |
| **Compilación** | GNAT · gprbuild |

---

## 🎓 Qué aprendí

- Que **la concurrencia segura se diseña**: un tipo protegido evita las carreras sin escribir un solo cerrojo a mano.
- A **temporizar con precisión** tareas periódicas con `delay until` y eventos de tiempo real.
- A **separar responsabilidades** entre quien mide, quien decide y quien actúa.

---

## 👤 Autoría

**Unai García** y **Jorge Caballero González** — Grado en Ingeniería Informática (Universidad de Salamanca)

- 🐙 GitHub: [@unaigb](https://github.com/unaigb)

---

<div align="center">

**⭐ Si este repositorio te resulta útil, considera darle una estrella.**

</div>
