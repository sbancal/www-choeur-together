---
title: Choeur Together
permalink: /
---

<div id="accueil" class="section">
  {% capture accueil %}{% include accueil.md %}{% endcapture %}
  {{ accueil | markdownify }}
</div>

<div id="qui-sommes-nous" class="section hidden">
  {% capture qui-sommes-nous %}{% include qui-sommes-nous.md %}{% endcapture %}
  {{ qui-sommes-nous | markdownify }}
</div>

<div id="notre-histoire" class="section hidden">
  {% capture notre-histoire %}{% include notre-histoire.md %}{% endcapture %}
  {{ notre-histoire | markdownify }}
</div>

<div id="rejoins-nous" class="section hidden">
  {% capture rejoins-nous %}{% include rejoins-nous.md %}{% endcapture %}
  {{ rejoins-nous | markdownify }}
</div>

<div id="contact" class="section hidden">
  {% capture contact %}{% include contact.md %}{% endcapture %}
  {{ contact | markdownify }}
</div>
