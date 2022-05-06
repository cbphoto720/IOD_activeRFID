# Radio Direction-Finding Antenna system
**Goals**
- long range direction detection of cobbles (rough initial cobble search)
- close range location detection of cobbles (<1m)
- low cost
- portable (handheld)

## Required materials
[take inspiration from this picture](https://dl.cdn-anritsu.com/images/products/tm-ma2700a/handheld-interferencehunter-ma2700a-environmental-2.jpg)<br />

## Toughpad Mounts
###### Toughpad chest mount
- talk to Rob about the lanyard that he uses for the drone<br /><br />
Best chest mount option (toughpad specific)
- [Ruxton Pack chest tablet carrier](https://www.tablet-ex-gear.com/products/ruxton-pack-medium)
- [optional toughpad mount (no adhesive velcro)](https://www.tablet-ex-gear.com/products/panasonic-fz-g1-standard-support-tray?pr_prod_strat=collection_fallback&pr_rec_id=5fb7d2366&pr_rec_pid=6766635614346&pr_ref_pid=6761233416330&pr_seq=uniform)<br /><br />
Backup chest mount option
- [less comfortable solution](https://www.ultimacase.com/op-case-pad-with-4-point-harness-for-getac-v110-v200.html)

###### Toughpad antenna mount
- I do have  a concern that mounting the toughbook to the antenna would be too heavy.
- [RAM low profile plate to ball female mount](https://www.rammount.com/part/RAP-200-1-293U)
- [RAM composite short arm](https://www.rammount.com/part/RAP-201U-B)
- [RAM rail mount](https://www.rammount.com/part/RAM-408-75-1U)
- [RAM generic 2 hole plate to type C ball](https://www.amazon.com/RAM-Mounts-Diamond-Ball-RAM-238U/dp/B007IDX27A/ref=sr_1_3?keywords=ram%2B1.5%2Bball%2Bmount&qid=1650481522&sr=8-3&th=1)

#### GPS Mounts
- cobble bacpack
- [take inspiration from tabletEXgear (mount to chest harness)](https://www.tablet-ex-gear.com/products/gps-antenna-pole-mounting-kit?pr_prod_strat=collection_fallback&pr_rec_id=5fb7d2366&pr_rec_pid=6761133047946&pr_ref_pid=6761233416330&pr_seq=uniform)

## Switchable Attenuator
- If we are going to pay for an expensive one: [0 to 70 dB Rotary Step Attenuator](https://www.fairviewmicrowave.com/70db-step-attenuator-10db-bnc-female-dc-2.2-ghz-2-watts-fmat1022-p.aspx?gclid=Cj0KCQjwma6TBhDIARIsAOKuANwnzlVWI7nLZV7MXTr9ugf9oLa7LxbuXSJJjgRutPOJtmbyLnhlkZwaAqcqEALw_wcB)
- switchable [attenuator box](https://www.rfparts.com/rfa4056-03.html)
- [DIY 2.5 GHz pi attenuator](https://youtu.be/A5gGeV7CiQ0?t=547)
  - what type of noise and signal would this introduce?
  -


## Custom antenna
[transceiver rf module RFM22B](https://dwmzone.com/en/sub-1ghz-rf-module/11-rfm22b-rfm23b-si4432-si4431-433mhz-868mhz-915mhz-hoperf-transceiver-rf-module.html)
- mentioned in this forum post: https://forum.arduino.cc/t/cheap-direction-finding/619610/2
- transmit and recieve 433 MHz
- arduino communication library [radiohead](http://www.airspayce.com/mikem/arduino/RF22/)
- hackable to accept external antenna
