# Glossary

English term, Persian equivalent, and the meaning used in this course. The
Persian column is the same convention used in `docs/fa/` and in the bilingual
READMEs.

| English | فارسی | Meaning |
|---|---|---|
| analysis | تحلیل | GHDL's parse + type-check stage, before elaboration |
| architecture | معماری | The implementation of an entity |
| array | آرایه | An indexed collection of same-typed elements |
| assertion | ادعا / اَسِرت | A condition that must hold; checked at run time or formally |
| asynchronous reset | ریست ناهم‌زمان | Reset that acts immediately, independent of the clock |
| attribute | ویژگی | Metadata attached to a type, signal, or entity (`'range`, `'event`) |
| backpressure | فشار معکوس | Receiver tells sender to stop, via `ready` low |
| BFM | مدل کارکردی گذرگاه | Bus Functional Model: procedures that speak a protocol |
| block RAM | بلوک RAM | Dedicated memory hard block in an FPGA |
| carry chain | زنجیرهٔ نقلی | Dedicated fast adder path in an FPGA |
| clock domain | دامنهٔ ساعت | Logic clocked by one clock source |
| clock enable | فعال‌ساز ساعت | `if en = '1'` inside a clocked process; replaces clock gating |
| component | کامپوننت | A declaration of an interface, bound later by a configuration |
| concurrent statement | دستور هم‌زمان | Statement outside a process; elaborates into implicit processes |
| configuration | پیکربندی | A declaration binding entities to architectures for a hierarchy |
| constant | ثابت | A named value fixed at elaboration |
| coverage | پوشش | Evidence that the tests exercised what they were meant to |
| delta cycle | چرخهٔ دلتا | A zero-time simulation step; signals update between them |
| DUT | طراحی تحت آزمون | Device/Design Under Test |
| elaboration | بسط | Building the hierarchy, resolving generics, connecting ports |
| entity | موجودیت | The interface (name, generics, ports) of a design unit |
| enumeration | شمارشی | A type with named literals (`type state_t is (IDLE, RUN)`) |
| FIFO | صف | First-In First-Out buffer |
| flip-flop | فلیپ‌فلاپ | One bit of clocked state |
| FSM | ماشین حالت | Finite State Machine |
| generic | جنریک / پارامتر عمومی | Compile-time parameter of an entity |
| GHW | GHW | GHDL's waveform format, keeps full type information |
| handshake | دست‌دادن | Protocol where both sides agree a transfer happened |
| instantiation | نمونه‌سازی | Creating an instance of an entity/component |
| latch | لچ | Level-sensitive unintended storage; usually a bug |
| latency | تأخیر | Cycles from input to corresponding output |
| LUT | جدول درست‌نمایی | Look-up table: the basic logic cell of an FPGA |
| Mealy machine | ماشین میلی | FSM whose outputs depend on state and inputs |
| metastability | فراماندگی | Unstable sampling when a signal changes near a clock edge |
| Moore machine | ماشین مور | FSM whose outputs depend only on state |
| package | بسته | A library unit holding shared types, constants, subprograms |
| pipeline | خط لوله | Registers between logic stages to raise throughput |
| port | درگاه | An interface signal of an entity |
| port map | نگاشت درگاه | The connection list of an instance |
| process | فرایند | A sequential region of code; the unit of sensitivity |
| PSL | PSL | Property Specification Language, temporal assertions in comments |
| RAM / ROM | RAM / ROM | Read-write / read-only memory |
| register | رجیستر | A bank of flip-flops holding a value |
| resolved type | نوع حل‌شده | A type with a resolution function for multiple drivers (`std_logic`) |
| reset | بازنشانی / ریست | Returning registers to a known state |
| RTL | RTL | Register Transfer Level: synthesizable behavioural description |
| scoreboard | جدول امتیاز / مرجع | Stores expected results and compares them asynchronously |
| sensitivity list | فهرست حساسیت | Signals that wake a process |
| sequential statement | دستور ترتیبی | Statement inside a process; executes in order |
| signal | سیگنال | A communication object updated at the end of a delta cycle |
| simulation | شبیه‌سازی | Executing the elaborated model over time |
| std_logic | std_logic | IEEE 1164 resolved 9-value logic type |
| subtype | زیرنوع | A constrained version of a type (`natural`, `integer range 0 to 9`) |
| synthesis | سنتز | Turning RTL into a netlist of gates/cells |
| testbench | بستر آزمون | A design unit with no ports that drives and checks a DUT |
| test vector | بردار آزمون | One set of input values plus expected outputs |
| throughput | توان عملیاتی | Results per unit time (usually per clock) |
| tristate | سه‌حالته | `'Z'` output; multiple drivers on a bus |
| valid/ready | معتبر/آماده | The standard streaming handshake pair |
| variable | متغیر | A local object updated immediately inside a process |
| VCD | VCD | Value Change Dump: portable, bit-level waveform format |
| waveform | شکل موج | A time plot of signal values |
| Yosys | Yosys | Open-source synthesis framework used in topic 10 |

---

See also: [Coming from Verilog](00-verilog-to-vhdl.md) ·
[Cheat sheet](05-cheatsheet.md) · [Persian glossary](fa/glossary.md)
