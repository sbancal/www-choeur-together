---
title: Choeur Together
permalink: /
---

{% capture accueil %}{% include accueil.md %}{% endcapture %}
{% capture qui-sommes-nous %}{% include qui-sommes-nous.md %}{% endcapture %}
{% capture notre-histoire %}{% include notre-histoire.md %}{% endcapture %}
{% capture rejoins-nous %}{% include rejoins-nous.md %}{% endcapture %}
{% capture contact %}{% include contact.md %}{% endcapture %}

<div id="accueil" class="section">
  {{ accueil | markdownify }}
</div>

<div id="qui-sommes-nous" class="section p-14 hidden">
  {{ qui-sommes-nous | markdownify }}
</div>

<div id="notre-histoire" class="section p-14 hidden">
  {{ notre-histoire | markdownify }}
</div>

<div id="rejoins-nous" class="section p-14 hidden">
  {{ rejoins-nous | markdownify }}
</div>

<div id="contact" class="section p-14 hidden">
  {{ contact | markdownify }}
</div>
