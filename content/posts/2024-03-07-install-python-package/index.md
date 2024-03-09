---
title: Irresponsible Expertise
date: 2024-03-07
category: Security
tags:
 - security
 - beginners
 - vulnerabilities

---



Are we experts teaching safe computing? Or are we teaching great power without great responsibility? Let's run a quick experiment and see what the evidence says.

Thanks to [Equal Experts](https://equalexperts.com) for supporting this content.

{{< ee >}}

<!--more-->



## The Python Ecosystem

Scope is a problem. For this experiment, I'm going to focus on Python experts and a risk-laden question that a beginner Pythonista will ask early in their journey - how do I install a package in Python?

Why Python? It's the main ecosystem I've been working in for the past few years. I think it's also particularly interesting because of the diverse community - not just folks who think of themselves as professional software developers, but data engineers, data scientists, analysts and hobbyists. That diversity is awesome but carries great responsibility for those who teach.

The Python ecosystem also has an uncommon feature in its package management system. In most package managers, installing a package just makes it available for use in your code. In Python, a package can choose to execute arbitrary code as part of its install process. According to security testing vendor [checkmarx.com](https://checkmarx.com/blog/automatic-execution-of-code-upon-package-download-on-python-package-manager/):

> Automatic code execution is triggered upon downloading approximately one-third of the packages on PyPI.

> When executing the well-known “pip install <package_name>” command, users may expect code to be run on their machine as part of the installation process.

Is there really a threat to a Python developer? Yes. One well-documented example from 2022 is the [W4SP stealer](https://www.darkreading.com/threat-intelligence/w4sp-stealer-aims-to-sting-python-developers-in-supply-chain-attack), discovered in 2022. What does this thing do when you install it? 

>  enumerates the victim's system, steals browser-stored passwords, targets cryptocurrency wallets, and searches for interesting files using keywords, such as 'bank' and 'secret'

When the linked article was published shortly after the discovery of the malware, packages known to contain this malware had been installed 5,700 times. It's not an isolated case. [This 2023 article from Sonatype](https://blog.sonatype.com/top-8-malicious-attacks-recently-found-on-pypi) enumerates eight more pieces of similar malware.


## The Experiment

I'm going to fire a query "install Python package" at Google in an incognito Chrome window in a minute. I'll then look at the top five results, whatever they are, and assess the content for how well they warn readers of the risks. Note that the results and content when you read this may differ from mine at the time of writing.

My hypothesis driving this post is that:

> popular articles explaining how to install Python packages put inexperienced users at risk by explaining how to run untrusted software on their computers without explaining the risks.

### Assessment

If I get a result that explicitly targets more advanced users who I'd expect to understand the risks, I'll highlight that and move on.
Otherwise, I'll assess against this set of criteria I've chosen to indicate whether I believe that the risk to the audience is increased or reduced by the article content, from worst to best.

- :bomb: means the article encourages bad practice
- :exclamation: means the article does not inform of risks
- :warning: means the article informs of risks
- :shield: means the article informs of risks and presents good advice

Specific points I'm looking for the article to cover if it's taking a responsible approach:

- :question: package installation can execute code
- :question: typosquatting is an attack vector
- :question: assessing trustworthiness for a package
- :question: packages can turn malicious in later versions
- :question: existence of vulnerability scanning tools
- :question: avoiding installation in system python

In case it's not obvious - I'm not an authority and these assessments represent my opinions on the content. If you don't trust my judgement, you can read the articles and make your own assessment.

Ready? Let's go.

## 1. Python Packaging User Guide

https://packaging.python.org/en/latest/tutorials/installing-packages

---

- :exclamation: package installation can execute code
- :exclamation: typosquatting is an attack vector
- :exclamation: how to assess trustworthiness for a package
- :exclamation: packages can turn malicious in later versions
- :exclamation: existence of vulnerability scanning tools
- :warning: avoiding installation in system python

---

Number one on the search results? Official documentation. Opening with detailed instructions to execute Python at the command line, this official Python documentation explicitly invites "newcomers" to participate.

Despite thousands of words dedicated to working around the system security constraints that might trip the audience up on their way to download untrusted software from the internet, I can't see any evidence that the article says anything about why those constraints are there and how they might be protecting you, and nothing on the other risks I'm looking for.

Not a great start! 

## 2. Python Documentation

https://docs.python.org/3/installing/index.html

---

- :bomb: package installation can execute code
- :exclamation: typosquatting is an attack vector
- :exclamation: how to assess trustworthiness for a package
- :exclamation: packages can turn malicious in later versions
- :exclamation: existence of vulnerability scanning tools
- :bomb: avoiding installation in system python

---

Number two is more official Python documentation. ~~It's the same story again~~ It's worse. Instructions for using venv avoid calling out the security-related risks around installing in the system Python installation. The last section on "installing binary extensions" implies the capability of installation to execute code but it doesn't call it out and links to [Installing Scientific Packages](https://packaging.python.org/en/latest/guides/installing-scientific-packages/) which encourages using old versions:

{{< figure src="./assets/2_versions.png"
    caption="Screen capture of python docs recommending old versions of packages" >}}

Later in the same document, advice to install to system Python for installers that require building from source and don't support virtual environments:

{{< figure src="./assets/2_system.png"
    caption="Screen capture of python docs recommending installation to system Python without mentioning risks" >}}

Because the search result links out to a document that encourages compiling from source and installing into the system Python, does not warn of any risks and explicitly targets scientists, I'm giving a couple of "encourages bad practice" grades.

## 3. Data to Fish

https://datatofish.com/install-package-python-using-pip/

Bear with me a moment, I need a new marking schema for this one.

---

- :bomb: explains nothing whilst instructing novice users to maximise risk and view system protections as an inconvenience

---

We open with:

{{< figure
    src="./assets/3_wtf.png"
    caption="Screen capture of datatofish.com advising Python newbies to blindly subvert system security" >}}

Wow. The rest of the articles continues in a similar vein of instructions with no warnings, so I'll not waste any more time here.

I wonder if they registered `datatophish.com` at the same time? If this is how bad things are by number three...


## 4. ListenData

https://www.listendata.com/2019/04/install-python-package.html

---

- :bomb: explains nothing whilst instructing novice users to maximise risk and view system protections as a ~~inconvenience~~ bug

---

A great start, let's open with this:

{{< figure
    src="./assets/4_adblock.png"
    caption="Screen capture of listendata.com's ad blocker disable banner" >}}

To be clear, I am "ad-tolerant" so I'm not using an ad blocker but I still get this drop-your-shields plea. I include it becuase it's again advising action without informing of consequences, and I think it informs us about the real motivations behind the article.

That probably tells us what we need to know about what follows. Skim... skim... ah, there you are, old friend.

{{< figure
    src="./assets/4_admin.png"
    caption="Screen capture of listendata.com advising Python newbies to blindly subvert system security" >}}

Done here. Moving on.

## 5. Python Land

https://python.land/virtual-environments/installing-packages-with-pip

OK, Number five. What horrors do you have in store?

Oh. Oh! You know what?

This is pretty good. This beats the official documentation and may well be the most responsible instructional article I've seen recently. My scoring matrix wasn't in vain!

---

- :exclamation: package installation can execute code
- :shield: typosquatting is an attack vector
- :shield: how to assess trustworthiness for a package
- :exclamation: packages can turn malicious in later versions
- :exclamation: existence of vulnerability scanning tools
- :shield: avoiding installation in system python

---

Here's an example.

{{< figure src="./assets/5.pythonland.png"
    caption="Screen capture from python.land showing considered, thoughtful and actionable advice to help users stay safe"
    >}}

## Summary

I set out to write this post pretty much as I wrote it. I'd noticed the lack of protective advice on my journeys so crafted the experiment, sketched out the criteria, ran the search and assessed the results.

I did not expect posts as shallow and dangerous as numbers 3 and 4 to be up in the top results. The official documentation is disappointingly weak on protective measures.

I'm so happy that the python.land post is in the top five. It gives me a reason to believe that much more carefully presented content can compete in the attention economy!

I'm thinking about how to follow this post up with positive action. Contacting the authors of these posts and/or suggesting improvements for sure. Maybe there's more I can do.

## A Request

I've struggled to find evidence about the real-world harm that this kind of vulnerability can cause. Lots of "organisation X got hacked", and lots of "presenting vulnerability Y". There must be real-world anecdotes related to the exploitation of individuals. I feel that kind of story would be a powerful reality check for this subject that can feel a bit like someone else's problem, especially if you're not doing this stuff professionally.

If you know of any news articles or other narratives that show real-world harms caused by Python package exploits, I'd love to hear about it. Social links on the blog!



