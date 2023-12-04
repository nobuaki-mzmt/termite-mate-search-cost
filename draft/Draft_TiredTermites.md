**Wasted efforts impair random search efficiency and reduce the level of
choosiness in mate-pairing termites.**

**Nobuaki Mizumoto<sup>1,2,3,4\*</sup>, Naohisa Nagaya**<sup>5</sup>**,
Ryusuke Fujisawa**<sup>6</sup>

**Affiliations:**

1\. Evolutionary Genomics Unit, Okinawa Institute of Science &
Technology Graduate University, Onna-son, Okinawa, Japan

2\. Computational Neuroethology Unit, Okinawa Institute of Science &
Technology Graduate University, Onna-son, Okinawa, Japan

3\. Department of Entomology and Plant Pathology, Auburn University,
Auburn, AL, USA

4\. Laboratory of Insect Ecology, Graduate School of Agriculture, Kyoto
University, Kyoto, Japan

5\. Department ofIntelligent Systems, Faculty of Computer Science and
Engineering, Kyoto Sangyo University, Motoyama, Kamigamo, Kita-ku,
Kyoto-City, Japan

6\. Graduate School of Computer Science and Systems Engineering, Kyushu
Institute of Technology, Fukuoka, Japan

\*. Author correspondence:
[<u>nobuaki.mzmt@gmail.com</u>](mailto:nobuaki.mzmt@gmail.com)

ORCID, N.M.: 0000-0002-6731-8684;

**Abstract**

Random search theories predict that animals employ movement patterns
that optimize encounter rates with target resources. However, animals
are not always able to achieve the optimal random search. Energy
depletion, for example, limits searchers’ movement activities, forcing
them to adjust their behaviors before and after the encounters. Here we
quantified the cost of mate search in a termite, *Reticulitermes
speratus*, and revealed that the cost reduces the selectivity of mating
partners. After a dispersal flight, termites keep searching for a mating
partner; otherwise, they die. We found that their movement activity and
diffusiveness progressively declined over observational days. Our
data-based simulations qualitatively confirmed that this reduced
movement diffusiveness decreased the searching efficiency. Also,
termites with prolonged search periods had lower colony foundation
success and fewer offspring. Thus, mate search imposes doubled costs on
termites. Finally, we found that termites with an extended mate search
reduced the selectivity of mating partners, where males immediately
paired with any encountering females and even frequently exhibited
same-sex pairing. Thus, termites dramatically changed their mate search
behavior depending on their physiological conditions. It is essential to
account for the searchers’ internal states to fill the gap between
random search theories and empirical behavioral observations.

**Keywords:** Random walk; Tandem runs; Sexual selection; Social
insects; Movement ecology

**Introduction**

When searching for targets whose location is unknown, animals benefit by
adopting movement patterns that promote random encounters. Random search
theories have predicted the best movement patterns that maximize
encounter rates with target objects, across a variety of environmental
conditions, including distribution and movement patterns of target
objects, time limitation, and ecological situations. Also, empirical
studies have shown that animals engage in optimal random search
strategies, especially focusing on the behavioral changes of the
searchers across differential searching environments. In random search
theories, however, although exogenous factors have been considered in
both theoretical modeling and empirical observations, studies have
rarely taken into account the indigenous conditions of searching agents.
Real animals dramatically change their physiological conditions,
including sexes, ages, and nutritional conditions. This limits the
connectivity between theories of random search and empirical
observations of animal searching behaviors.

Mating is one of the main motivations for search, and both females and
males evolved optimal sex-specific movement patterns to maximize mating
encounters. During mate searches, an encounter is one of the goals but
not everything. Once they encounter the potential mating partners, then
they need to make a decision to mate with the encountered individuals.
Thus, enhancing mating encounters is critical before the encounter,
while evaluation of the mating partner will be involved after
encounters. In random search theories, because movement patterns
influence the frequency of mating encounters netween partners, it also
has a strong influence on the subsequent decision. However, the
relationships between moving patterns and mate choice remain totally
unknown. To achieve optimal mating encounters, animals should
plastically adjust movement patterns. However, if they could not achieve
the optimal movements before encounters, due to physiological
conditions, mate searchers could plastically adjust their subsequent
mate choice after encounters.

To fill this gap and study the plastic changes of random search,
*Reticulitermes* termites provide an ideal system. During a certain
season of the year, alates (winged reproductives) fly to disperse for
mating. After dispersal, termites shed their wings, walk to search for
mating partners, and, upon successful encounters, perform tandem runs to
stay together while looking for a potential nest site (Fig. 1A)
(Nutting, 1969). In this process, both females and males of termites
flexibly change their random search strategies to enhance mating
encounters. Before encounters, both females and males actively explore
the environments to cover the wide regions (Mizumoto and Dobata, 2019),
while leaders pause and followers move to enhance reunion once they are
accidentally separated during tandem pairing (Mizumoto et al., 2022;
Mizumoto and Dobata, 2019). Pairs excavate wood or soil to establish a
nest as soon as they start tandem runs. Mate search is the only behavior
of these dealates, and mate search will last until they find a partner,
otherwise, they die (Mizumoto et al., 2016). If they could not find a
partner, the mate search could last multiple days (Kusaka and Matsuura,
2017; Mizumoto et al., 2017b), with photoperiodic circadian rhythms
(Mizumoto et al., 2017b). The mate search could be highly costly, given
that termites do not feed and obtain energy until they start a new
colony (refs), and social isolation is exceptional in their life history
(Koto et al., 2015). Thus, the costs associated with mate search must
have a strong impact on their searching and mating strategies.

In this study, we quantify the cost of mate search and investigate its
influence on the mate searching behavior in a termite, *Reticulitermes
speratus* (Kolbe 1985). We force dealates to search for mating partners
without encountering for 72 hours and examine how this alter their
movement patterns, colony foundation success, and mate choice.

Movement patterns. Diffusiveness is important parameters. Pausing is
too. All of them can be obtained using servosphere.

**Results**

**Change of searching activity over time**

After the swarming flights, both females and males actively move to
search for a mating partner in *R. speratus* (Mizumoto and Dobata,
2019). However, according to time, the search activity was progressively
reduced (Fig. 1B). Traveled distances during 25 minutes observations
were significantly declined according to observational day **(**LMM,
LRT, day: χ<sup>2</sup><sub>3</sub> = 98.9, *P* \< 0.001, Fig. 1C), with
females moving more distances than males (χ<sup>2</sup><sub>1</sub> =
4.5, *P* = 0.033). Similarly, both females and males paused for a longer
duration according to observational day **(**LMM, LRT, day:
χ<sup>2</sup><sub>3</sub> = 71.7, *P* \< 0.001, Fig. 1D), with no sexual
differences **(**χ<sup>2</sup><sub>1</sub> = 1.84, *P* = 0.17, Fig. 1D).
This difference of movement activities turned out the different
diffusive properties of termites. Termites just after swarming had the
largest MSD, and the value of MSD decreased according to days after
swarming (LMM, LRT, day: χ<sup>2</sup><sub>3</sub> = 398.9, *P* \<
0.001, Fig. 1E). Note that the slopes did not change according to
observation days in termites (LMM, LRT, interactions between day and τ:
χ<sup>2</sup><sub>3</sub> = 5.89, *P* = 0.11), indicating that the
decrease of MSD was caused by changes of movement activities, such as
movement speed and pausing duration, rather than the type of random
walks, e.g., changes of turning patterns or Lévy walk properties.
Therefore, the observed behavioral changes did not reflect the changes
of random search strategies but inactivity of termites, perhaps caused
by energy depletion.

When termites search for a mating partner, whose location is unknown to
searchers, high diffusiveness is critical for the encounter efficiency
(Mizumoto and Dobata, 2019), as shown in theoretical studies on random
search when the targets are randomly distributed and searchers do not
have any prior information on targets (James et al., 2008; Mizumoto et
al., 2017a). Because termites moved less distances with less diffusive
properties with longer pauses (Fig. 1B-E), searching efficiency is
expected to reduce according to extended mate search. Accordngly, our
data-based simulations demonstrated that searching efficiency of
termites was progressively reduced according to observation days (Fig.
1F). In both females and males, searching efficiency was highest in
termites just after the swarming, which showed the highest diffusive
properties (Fig. 1EF), and lowest in termites after 3 days that had the
lowest diffusive properties (Fig. 1EF).

<img src="media/image1.png" style="width:6.69291in;height:5.88618in"
alt="A screenshot of a computer Description automatically generated" />

> **Figure 1.** Change of movement patterns according to extended mate
> search in a termite *Reticulitermes speratus*. (A) Overview of the
> mating biology and experimental setup. After swarming flights,
> termites shed their wings and walk to search for a partner. After
> successful encounter, they form a tandem running pair and found a
> colony. Mate search usually ends in a day, otherwise it can last until
> they find a partner. We observed their movement patterns every 24
> hours for 30 minutes over 4 days (day 0-3). (B) Representative
> trajectories of a termite. Each trajectory corresponds to 25 minutes,
> where a termite moved less and less distances across days. (C-D)
> Comparison of traveled distances (C) and pausing duration (D) of
> termites across days after swarming. Bars indicate mean ± s.e. (E)
> Mean squared displacements (MSD) of the trajectories on the
> servosphere across days after swarming. Thick lines indicate mean for
> each day’s observations, where data of females and males were pooled.
> (F) Simulation results for comparing searching efficiencies of
> movement patterns observed in termites across days after swarming (*L*
> = 223.6, φ = 7). The results were obtained from means of 100,000
> simulations.

*Fitness cost of extended mate starch*

We found that extended mating search incurs the cost on colony
foundation success. The colony foundation success was significantly
reduced in termite pairs that experienced 3 days extended search,
compared with those found a colony just after swarming (GLMM, LRT, sex:
χ<sup>2</sup><sub>1</sub> = 4.02, *P* = 0.04; Fig. 2B). Also, even after
the successful colony foundations, pairs with extended mate search had
the significantly smaller number of offspring (GLMM, LRT, sex:
χ<sup>2</sup><sub>1</sub> = 4.14, *P* = 0.04, Fig. 2C).

<img src="media/image2.png" style="width:5.08333in;height:2.64583in" />

> **Figure 2.** Comparison of colony foundation success between alates
> just after swarming and after 3 days mate search.

*Changes in tandem pairing after extended mate search*

Extended mate search in isolation dramatically increased the motivation
of tandem running behavior in termites. In total, we observed 219 tandem
runs for termites just after swarming (166 heterosexual, 36
male-male,one female-female tandem run, and 16 tandems with \>2
individuals), while 679 for termites that experienced 72 hours mate
search (564 heterosexual, 30 male-male, six female-female, and 79
tandems with \>2 individuals), during 30 minutes observations. Termites
with extended mate search showed significantly larger number of
heterotrophic tandem runs (Wilcoxon Signed rank test, *V* = 0, *P* =
0.03; Fig. 3B) and tandem runs with more than two individuals (Wilcoxon
signed rank test, *V* = 0, *P* = 0.03; Fig. 3B), but not male-male
(Wilcoxon signed rank test, *V* = 14, *P* = 0.56; Fig. 3B) and
female-female tandem runs (Wilcoxon signed rank test, *V* = 1.5, *P* =
0.375; Fig. 3B). Most tandem runs with more than two individuals were
that two males following one female (84/95; 88.4%). There was no
significant difference in the number of tandems between nest-mate or
non-nest mate pairing in all these pairing combinations (Wilcoxon signed
rank test, 0 day: *V* = 10, *P* = 1; 3 day: *V* = *8*, P = 0.6875).

Furthermore, between termites with and without extended mate search, we
found distinct patterns of time development of tandem pairing. In
termites just after swarming, the number of observed tandem runs
increased according to the observational periods, where termites exhibit
fewer tandem runs soon after being introduced to the arena (Spearman’s
rank correlation, *S* = 3.55, *P* = 0.01; Fig. 3A). On the other hand,
in termites with extended mate search, the number of tandem runs was
higher than the last 5 minutes of termites just after swarming and did
not increase according to observational periods (Spearman’s rank
correlation, *S* = 26, *P* = 0.66; Fig. 3A). Thus, the motivation of
tandem runs was highest in termites with experiencing extended searches,
while it increased according to time in termites just after swarming.

<img src="media/image3.png" style="width:3in;height:4.8105in" />

> **Figure 3.** Comparison of observed tandem runs between termites just
> after swarming (0 day) and termites that experienced isolated mate
> search for 72 hours (3 day).

**Discussion**

Mate search incurs the doubled costs to termites. First, termites
traveled less distance and discounted the diffusive properties after the
extended mate seach peridod (Fig. 1). As fast and diffusive movements
are beneficial to increase encounter efficiency in termite mate search
(Mizumoto and Dobata, 2019), reductuion of movement capacity decreases
mating encounters (Fig. 1F). Such inactivity of termites with extended
mate search could be caused by the energy depletion (Wickman and
Jansson, 1997) because termite reprductives use reserved fat body for
dispersal flight and colony foundations and do not obtain further energy
until they successful start establishing the new colonies (refs).
Therefore, energy costs associated with mate search further decreased
the colony foundation successes and the number of offspering after
foundations. As a social insect, it is highly costly to be isolated for
longer period to search for a mating partner.

To compensate the reduction of the probability of mating encounters due
to inactivity, termites adjusted their mating preferences after the
extended searches. Termites that experienced the extended searches had
the much figher motivation for pairing than those just after swarming,
where males followed any females upon encounters. In such populations
with extended searches, two males competite with each other to obtain a
single female. Simialr changes in mate choice preferences can be
observed in other animals, especially those have multiple mating
partners. In species with female choocing male partners, the levels of
selectivity by females are relaxed, e.g., when the life expectancy of
females is short (Wilson et al. 2010; Wilgers and Hebets 2012), lack of
males (Alatalo et al. 1988), short mating season (Gotthard et al. 1999).
Furthermore, males that are isolated for longer periods often show
same-sex pairing as they cannot miss the partner (Engel biol lett).
Thus, random search strategy does not soley mating strategy of temrites,
rathter they combined it with other decision making to achieve rational
mate search.

Tandem pairing dynamics of termites was distinct between individuals
just after swarming and with extended mate search. Especially, in
termites just after swarming, the number of observed tandem runs was
increased during observational periods (Fig. 3A), while it was highest
since the beginning in the inidividuals with extended mate search. This
patterns could be interpreted with sequential choice model (Real 1990;
Real 1991). The sequential choice model is also called “secretary
problem,” where decision-maker try to select the best option from a
sequentially presented set of options. Like termite tandem pairing,
serachers must make the decision upon encountering the option cannot
revisit the previous option once reject it (Ferguson 1989). Here, one of
the optimal strategy is rejecting fist several options to learn the
qualities of options and then making a choice based on the previous
experience. In our experimental conditions, because males just after
swarming are expected to encounter many females, they can evaluate
multiple females before select a partner for tandem running. On the
other hand, for males with extended mate search, the number of females
they expect to encounter will be quite small. Thus, males do not reject
partners for evaluation but engage in tandem runs as soon as they
encounter females. Our results shed light on the cognitive capacity of
termite mate searchers.

Cross species variation. Some species should be less choosy. While
others can be somewhat choosy. Males may chooce partners (Mizumoto et
al., 2021). However, everything could be secondary because most
important is to make a pair. This, it is surprising that termites might
refrain pairing with a partner for the first several minutes. This
indicates choosing better partners could provide enough strong
advantages for colony foundation success. Not that several studies show
that termites with some characters are strong candidate of mating pairs,
larger body size, without leaking body parts, microbial community,
heterozygosity, and so on. However, it is questionable how termites can
distinguish these partners, given that they even do not care the species
of their partners. Their interindividual interactions are mostly limited
in touching with antenna. Passive selection, e.g., strong candidate are
better at tandem run, may be a cause of assistive mating, rather than
active mate choice.

In the theory of optimal random search strategies, conditions of
individual searchers have rarely been taken into account, and seachers
can show the best performance during searching periods. However, our
study showed that searching activity itself can affect their movement
capacity, which not only alter their movement patterns but also
sequential decision-making after encounters. By filling the gap between
theoretical studies on ideal searching conditions and empirical
observations on realistic searching situations, our study contributes to
the understanding of the evolution of random search strategies adapted
in animals.

**Material and Methods**

*Termite*

We collected *R. speratus* alates with a piece of nesting wood from
seven colonies in Kyoto in May 2016 and 2017. May is the swarming season
of this species in Kyoto. To control flight timing, all nesting wood
pieces were maintained at 20°C until experiments. Before each
experiment, we transferred nests to a room at 25°C, which promoted
alates to emerge and fly. Alates were then collected and separated by
sex. We used individuals who shed their wings by themselves. We stayed
all experiments within 24 hours after the swarming flight.

*Change of searching activity over time*

We investigated how searching activities change according to time after
swarming flight using three colonies collected in 2016. We investigated
the search activity of nine females and nine males (three from three
colonies). Each individual was placed on an omnidirectional servosphere
(Nagaya et al., 2017) and freely walked on an infinite two-dimensional
surface for 30 minutes. The observation was performed four times every
24 hours, i.e., just after swarming (= day 0), day 1, day 2, and day 3.
Termites were individually maintained in a Petri dish (φ = 90 mm) with a
moistened piece of filter paper (a quarter of 70 mm). The bottom of the
dish was polished so that termites could walk smoothly on the dish. We
maintained each termite under the light condition of 16L8D and at 25°C
during the interval of each observation. The observations were performed
during the time of light conditions.

Because the sampling rates of data acquisition were not constant in our
servosphere, we smoothed the coordinates data with a median filter (k
=5) and interpolated them to obtain the coordinates every 0.2 seconds
(5Hz). We removed data for the first five minutes and used the rest for
25 minutes for further analysis.

First, we obtained the moved distance every 0.2 seconds (steplength). By
summing up these steplengths, we calculated the total distances termites
walked during 25 minutes. Also, we examinied pausing duration during
this period. In *Reticulitermes speratus*, the previous study estimated
that the threshold for moving and pausing was 0.7mm (Mizumoto and
Dobata, 2019); termites are regarded as moving if they moved more than
0.7mm in 0.2 seconds, while they are pausing if less than 0.7mm. We
measured the total pausing duration during 25 minutes observations.
Then, we investigated the effect of time after swarming on walking
distracts and pausing durations, using linear mixed models (LLM) that
includes time after swarming (0, 1, 2, and 3 days after swarming), sex,
and their interactions as fixed effects, and the original colony as the
random effect (random intercept). The statistical significance of each
variable was tested using the chi-square test (type II ANOVA), herein,
and the following statistical analysis.

Second, we evaluated the diffusive properties of individual movements.
High diffusiveness is critical for the efficiency of random search when
the targets are randomly distributed and searchers do not have any prior
information on tagets (James et al., 2008; Mizumoto et al., 2017a),
which is relevant for termite mate search before encounters (Fig. 1A)
(Mizumoto and Dobata, 2019). We computed the mean squared displacements
(MSD) to compare the diffusive properties of individual movements across
time after swarming. The MSD is defined as the mean of squared distance
that an organism travels from its starting location to another point
during a given time, τ. We obtained MSD in the range of 0.2 \< τ \<
1500, using the function *computeMSD*() in the package “flowcatchR”. To
compare the MSD between time after swarming, we used a LMM, where τ,
time after swarming, sex, and their interactions were included as fixed
effects, and individual ids nested within original colonies were
included as a random effect (random intercept). MSD and τ were log
transformed before the LMM fitting.

*Evaluation of searching efficiency*

Because termites moved less distances with less diffusive properties and
a lot of pauses (Fig. 1B-E), searching efficiency is expected to reduce
according to extended mate search. To quantify the searching efficiency,
we used a data-based simulation approach. We projected trajectories of a
female and a male after randomization and calculated if and when they
encountered. When mate search of termites extended to multiple days,
they synchronize their search efforts with the following swarming events
(Mizumoto et al., 2017b). Given that most termites do not extend mate
search for multiple days due to pairing or predation (Mizumoto et al.,
2016), we expect that mating encounters of extended mate searchers are
usually with new mate searchers (day 0 individuals). Thus, we
investigated the encounter efficiency in the combinations of 0 day-0
day, 0 day-1 day, 0 day-2 day, and 0 day-3 day trajectories. We picked
up one trajectory with 5 FPS of a female and a male and place them at a
random location in a periodic boundary condition of size = *L* × *L*.
Each trajectory was horizontally and vertically reversed with the
probability of 1/2. Following inversion, we rotated the trajectory at
random degrees from 0 to 360 around the starting point of the
trajectory. After projecting two trajectories, we estimated if and when
these two individuals encountered. We regarded they encountered when two
are within the distance φ at the same time. We performed this process
100,000 times for eight cominations (0 day-0 day, 0 day-1 day, 0 day-2
day, and 0 day-3 day, for female-male and male-female). The parameter φ
value was set as 7 mm, based on the body size of *R. speratus* (Mizumoto
and Dobata, 2019), and *L* as 223.6, based on the previous studies
(Kusaka and Matsuura, 2017; Mizumoto and Dobata, 2019).

*Fitness cost of extended mate starch*

We investigated the long-term fitness cost of extended mate search after
colony foundation using four colonies collected in 2017. We prepared
termite females and males that were isolated for 72 hours in a Petri
dish described above. After 72 hours of isolated mate search, these
termites were paired with each other. Similarly, we also prepared pairs
of termites just after swarming. Each pair was introduced to a Petri
dish (φ = 40 mm) filed with brown-rotted pinewood mixed cellulose medium
in a depth of 5 mm (Mitaka et al., 2023), where termites excavated into
the medium to establish their nests. All pairs were produced using
nestmate. We prepared 12 pairs for each condition in three colonies and
nine pairs for one colony. As several individuals were dead during 72
hours isolated mate search, we had 45 pairs for just after swarming and
39 pairs after 72 hours of matter search, in total.

All dish were maintained at 25℃ in dark condition for 60 days. After 60
days, we opened all dish and counted the number of surviving individuals
(female, male, larvae, and eggs, separately). We defined that the pair
succeed in colony foundation only when both female and male were
surviving. We compared colony foundation success between just after
swarming and 72 hours after swarming, using a generalised linear mixed
model (GLMM) with binomial distribution and logic link function, in
which termite condition was included as fixed effect, while original
colony was included as random effect (random intercept). We also
compared the number of eggs and larvae between termite conditions among
pairs that succeeded in colony foundation. We used a GLMM with Poisson
distribution, otherwise the same with the other one.

*Change of fresh weight and mate preference*

Fresh body weight is often used as an indicator of the quality of
termite dealates (refs), where heaviwer termites are preferred as mating
partners. We examined how body weght could change during extended mate
search and how it affected the mating preferences. Using three colonies
collected in 2016, we compared the fresh weights of eight females and
males for each colony just after swarming and after 72 hours mate
search. Measurements were performed on a scale of the 0.01 mg.

To investigate the mate preference of termites, we observed the mate
competition situations between termites just after swarming (new) and
after 72 hours mate search (old). We introduced three termite dealates
(new female-old female-new male or new female-new male-old male) in a
petri dish arena (φ = 90 mm) filled with moistened plaster. After 10
minutes of introduction, we confirmed if the new individidual waas
tandem pairing with new opposite sex indidivudal or the old individual
was pairing. We used binomial test to test the bias in pairing
combinations (old or new). All three indidivudals were from different
colonies.

*The effect of extended searching on tandem pairing occurrence*

We investigated how extended mate search affect the pairing dynamics,
using colonies collected in 2016. After swarming, ten females and ten
males of dealate were selected from two different colonies. These 40
individuals were paint marked with one colored on the abdomen for sex
and colony identification (PX-20; Mitsubishi). All 40 individuals were
maintained for 30 min (just after swarming) or 72 hours (extended mate
search) separately in a 24 well plate before the observation. Note that
the results of 30 minutes treatment were already reported in (see Text
S1 of (Mizumoto et al., 2022)).We introduced 40 individuals to the
experimental arena (ø = 600 mm). The experimental arena consisted of a
Styrofoam board (600 x 600 mm) and a circular plastic tube (ø = 600 mm,
height = 100 mm). After being introduced in the arena, we observed
termite movements for 30 minutes within a part of the experimental arena
(200 x 100 mm) located at the edge of the circular arena (Fig. S2). We
did so because most individuals walked along the edge of the arena,
repeatedly passing across the observational arena (Video S1 and S2). We
counted the number of individuals passing across the observational area
with their status (single individuals, heterosexual tandems, same-sex
tandems, tandems with \>3 individuals). We performed the experiments six
times with different colony combinations for each treatment. The
experimental arena was cleaned with 70% ethanol and distilled water
before each experiment.

We compared the total number of observation of pairing units between
termites just after swarming and after extended mate search, using
Wilcoxon signed rank test. We also investigated the time development of
observed tandem running pairs. We binned our 30 minutes observation into
0-5 minutes, 5-10 minutes, …, 25-30 minutes and counted the number of
observed tandem pairs during each time-windows. We used spearman’s rank
relation test to test if the number of observed tandem running pairs
increase according to time developments.

All analysis were performed by R v4.3.1 (R Core Team, 2023) with
libraries of “lme4”, “car”, and “exactRankTests” for statistical tests,
and “Rcpp” for data-based simulations. All data with R and Cpp scripts
are available at GitHub
(github.com/nobuaki-mzmt/termite-mate-search-cost). The accepted version
will be uploaded to Zenode to obtain DOI for the version of record.

**Acknowledgments**

We thank Shigeto Dobata, Kenji Matsuura, and Tomonari Nozaki, for
valuable intellectual inputs for the experiments, and XXX for help with
termite collections. This study was supported by Grants-in-Aid for JSPS
Research Fellow 15J02767 (NM) and an IPSF fellowship from OIST.

**Author Contributions**

N.M.: conceptualization, data curation, formal analysis, funding
acquisition, investigation, methodology, project administration,
resources, supervision, validation, visualization, writing-original
draft, writing-review and editing. N.N.: resources, softwares,
writing-review and editing. R.F.: resources, softwares, writing-review
and editing.

**Competing Interest Statement**

The authors declare that they have no conflicts of interest in the
contents of this manuscript.

**References**

James A, Plank MJ, Brown R. 2008. Optimizing the encounter rate in
biological interactions: Ballistic versus Lévy versus Brownian
strategies. *Physical Review E* **78**:051128.
doi:10.1103/PhysRevE.78.051128

Koto A, Mersch D, Hollis B, Keller L. 2015. Social isolation causes
mortality by disrupting energy homeostasis in ants. *Behavioral Ecology
and Sociobiology* **69**:583–591. doi:10.1007/s00265-014-1869-6

Kusaka A, Matsuura K. 2017. Allee effect in termite colony formation:
influence of alate density and flight timing on pairing success and
survivorship. *Insectes Sociaux* **65**:17–24.
doi:10.1007/s00040-017-0580-9

Mitaka Y, Akino T, Matsuura K. 2023. Development of a standard medium
for culturing the termite Reticulitermes speratus. *Insect Soc*
**70**:265–274. doi:10.1007/s00040-023-00907-6

Mizumoto N, Abe MS, Dobata S. 2017a. Optimizing mating encounters by
sexually dimorphic movements. *Journal of The Royal Society Interface*
**14**:20170086. doi:10.1098/rsif.2017.0086

Mizumoto N, Bourguignon T, Bailey NW. 2022. Ancestral sex-role
plasticity facilitates the evolution of same-sex sexual behavior.
*Proceedings of the National Academy of Sciences of the United States of
America* **119**:e2212401119. doi:10.1073/pnas.2212401119

Mizumoto N, Dobata S. 2019. Adaptive switch to sexually dimorphic
movements by partner-seeking termites. *Science Advances*
**5**:eaau6108. doi:10.1126/sciadv.aau6108

Mizumoto N, Fuchikawa T, Matsuura K. 2017b. Pairing strategy after
today’s failure: unpaired termites synchronize mate search using photic
cycles. *Population Ecology* **59**:205–211.
doi:10.1007/s10144-017-0584-3

Mizumoto N, Lee SB, Valentini G, Chouvenc T, Pratt SC. 2021.
Coordination of movement via complementary interactions of leaders and
followers in termite mating pairs. *Proceedings of the Royal Society B:
Biological Sciences* **288**:20210998. doi:10.1098/rspb.2021.0998

Mizumoto N, Yashiro T, Matsuura K. 2016. Male same-sex pairing as an
adaptive strategy for future reproduction in termites. *Animal
Behaviour* **119**:179–187. doi:10.1016/j.anbehav.2016.07.007

Nagaya N, Mizumoto N, Abe MS, Dobata S, Sato R, Fujisawa R. 2017.
Anomalous diffusion on the servosphere : A potential tool for detecting
inherent organismal movement patterns. *PLoS ONE* **12**:e0177480.
doi:10.1371/journal.pone.0177480

Nutting WL. 1969. 8 Flight and colony foundation. In: Krishna K, Weesner
FM, editors. Biology of Termites. New York: Academic Press. pp. 233–282.
doi:10.1016/B978-0-12-395529-6.50012-X

R Core Team. 2023. R: A language and environment for statistical
computing.

Wickman P-O, Jansson P. 1997. An estimate of female mate searching costs
in the lekking butterfly Coenonympha pamphilus. *Behavioral Ecology and
Sociobiology* **40**:321–328. doi:10.1007/s002650050348

**Supplemental materials**

**Figure S1**. Trajectories on the servosphere of all observed
individuals.

**Figure S2.** Observational arena for tandem pairing.

<img src="media/image4.png" style="width:7in;height:4.10417in" />

> **Figure S1**. Trajectories on the servosphere of all observed
> individuals. Each label indicates Species name (Rs = *Reticulitermes
> speratus*) + Colony name + Sex + Replicates.

<img src="media/image5.png" style="width:2.95833in;height:3.08333in" />

> **Figure S2.** Observational arena for tandem pairing. A video camera
> was located above the observation area on a tripod. Termites were
> released at the center of the arena, and those who crossed the
> observation area were observed.
