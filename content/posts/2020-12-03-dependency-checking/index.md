---
title: Dependency Checking
date: 2020-12-03
category: DevOps
tags:
 - gotcha
 - dependency-check
 - security
description: Should you check dependencies on every push?
---

These days, checking your dependencies for vulnerabilities is a common practice.
We can use great tools like [OWASP Dependency Check](https://jeremylong.github.io/DependencyCheck/), [Trivy](https://github.com/aquasecurity/trivy) and [Snyk](https://snyk.io) in our builds to raise the alarm when vulnerabilities are found.

The question that I find comes up isn't whether we should check dependencies - but **when**?

## The Options

### Check on Push

I'd bet the first time you put a dependency check into your build, you did what I did. You run the check when you push. When the check fails, you break the build.

On its own, it's a terrible solution. A vulnerability can be released at any time, regardless of when you happen to push changes. You might never find out that a service you're not actively working on has a known and fixable vulnerability - and that might be how the criminals who stole your customer data got in. Ouch.

There's a nasty tradeoff with this approach, too. I've pushed a change to a repository in a highly capable and fast-moving remote-first team and had the build fail because a vulnerability happened to just have been released. I stop, scrambling to see why my build failed. People around me are pushing and having their builds fail too. Half the team screeches to a halt and has to co-ordinate looking at the vulnerability, deciding what to do and getting that change made, pushed and the build made green again. In a less well co-ordinated team (or the same team on a bad day) he whole thing can quickly resemble a motorway pile-up.

Is it a worthwhile tradeoff to jump on that vulnerability as quickly as possible? The safe answer is "yes, of course, because security"  - but I'm going with no, not in most teams.

What if the same vulnerability had been announced a few hours later, after the last push of the day? Would anyone have looked at it before the following morning, twelve-or-more hours later? If it was the Thursday before the UK's Easter four-day holiday, we're talking around 100 hours before anyone's due to log on.

Your time between a vulnerability that affects you becoming public knowledge and you becoming aware of it varies unpredictably between seconds and never. Not good.

### Check on Schedule

To address those issues you'll set up a scheduled build. It runs the dependency check and alerts the team to issues rather than breaking the build. Now you've got a specific worst-case time to discovery. A nightly build sets that time to 24 hours, but you could schedule more frequently - an hourly build means you'll know within the hour.

Scheduling your dependency check works regardless of how frequently you push. You don't get the broken build knocking unrelated work off track and you can plan your vulnerability management activities into your team's roles and other activities.

Now that you know, worst case, how long it will take you to discover a vulnerability, you can start thinking about your vulnerability management as part of how you run your service. It forces you to accept that there's time between a vulnerability being announced and you becoming aware that you're affected. If you're anything like me, that will mean you'll start worrying more about how to respond effectively. You'll start asking questions you hadn't though of before, like:
- How do I know that I wasn't already compromised?
- How do I respond efficiently when half a dozen repositories are affected by a vulnerability in a common library?
- How can I be sure you're actually running scheduled checks across multiple repositories?

One last question: should you still check on push? You could, and it would be much less disruptive now you have an alerting channel that doesn't break the build. I'd argue there's not much value and some cost of unplanned disruption in doing so though, once you have your scheduled builds and agreed your response times. I'd advocate for focusing more on an effective response to the vulnerability alerts you get from your scheduled checks.

### Register and Notify

I've had a little informal experience with Snyk lately, and it seems to offer a third option which might point us toward a brighter future. Instead of constantly checking your dependencies in each build, you push your dependency lists to them, and they notify you when a vulnerability is announced that affects you.

In my opinion, that's a really appealing model. It's really neat to get the emails saying that a new vulnerability is out there that I affects my projects. Not only does it seem to minimise the time to find out about a vulnerability that affects you, but it cuts out the complexity of per-build scheduling. It's free for open source projects (yay) but you'll pay for commercial use.

