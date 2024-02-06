---
title: PyPI Download History
date: 2024-02-06
category: Analytics
tags:
 - python
 - vulnerabilities
 - security
 - dbt

---

Following [initial exploration and setup](../2024-01-19-pypi-vulnerabilities-setup/index.md), I wanted to pull in more history from my safety and pypi sources to get a better idea of what might be happening. I also wanted to keep the data up to date automatically.

I'll cover the challenges in setting up those feeds and how the numbers in the last post turned out to be wrong. Over a couple of posts. First up - Safety DB vulnerability history!

Thanks to [Equal Experts](https://equalexperts.com) for supporting this content.

{{< ee >}}

<!--more-->

## In the Last Thrilling Episode...

I had extracted download data from the open PyPI dataset for the arbitrary recent-ish date 2023-11-05, noting the large volumes and high costs involved in processing the source dataset. I extracted a single SafetyDB snapshot from the month before the download data, built some functions to match semver constraints and created some views and tables to pull out more usable views of the data and some summary statistics. I used that data to produce an overall proportion of known-vulnerable downloads that day of 5.2% or around 32m downloads.

That number was **wrong**. The first part of why starts now.

## Obtaining Safety History

I wanted to look further than just a single day's downloads. That would open up a lot of ways to look at patterns in the data and helps to avoid an atypical day leading to the wrong conclusions. In order to do that, I'll need both Safety DB and PyPI histories, so I started with Safety - being the smaller dataset.

Each month, [Safety Cybersecurity (formerly pyup.io)](https://github.com/pyupio) commit updates to the [safety-db repo](https://github.com/pyupio/safety-db). To establish a history, I need to work back through the commits, fetch the database JSON file, and load it into BigQuery. Not too challenging - the GitHub API is easy enough to work with to get the commit list and then the version of the file for each commit.

I don't know of any way to interact with GitHub in this way without scripting it myself, and I dont want to bring in any dependencies that aren't absolutely necessary. The script I wrote to do that is [here](https://github.com/brabster/pypi_vulnerabilities/blob/64812282d8c94d32a769723fdb99da3b2a97d861/etl/safety_db/load_missing_partitions.py). Essentially, it:

- gets the list of commits on the database file from GitHub
- checks which commits are already present in the target dataset table, filtering those out of the orignal list
- for each remaining commit
  - fetch the file content JSON
  - wrap the content with some metadata
  - merge into target dataset table

Given that the commit history is immutable, this approach avoids unnecessary time spent downloading and uploading data that we already have.

|Backfilling Safety DB history in [the first build](https://github.com/brabster/pypi_vulnerabilities/actions/runs/7716571519/job/21033677275)|
|-|
|![Backfilling Safety DB history](./assets/safety_init_load.png)|

|[First build on Feb 2nd](https://github.com/brabster/pypi_vulnerabilities/actions/runs/7716571519/job/21033677275) loads February's commit|
|-|
|![First build on Feb 2nd loads February's commit](./assets/safety_next_load.png)|

## Taking a Look

The raw table isn't that useful, as it's organised as a list of vulnerabilities per packge. I've laid a view over it to expand that into a row-per-vulnerability, which is much more useful. Example:

```sql
SELECT
  *
FROM `pypi-vulns.published_us.safety_vulnerabilities`
WHERE package = 'requests'
  AND commit_date BETWEEN '2023-10-01' AND '2023-11-01'
LIMIT 10
```

|package|commit_date|specs|cve|previous_commits|until_date|
|-------|-----------|-----|---|----------------|----------|
|requests|2023-10-01|"[>=2.1,<=2.5.3]"|CVE-2015-2296|26|2023-11-01|
|requests|2023-11-01|"[>=2.1,<=2.5.3]"|CVE-2015-2296|27|2023-12-01|
|requests|2023-10-01|"[>=2.3.0,<2.31.0]"|CVE-2023-32681|4|2023-11-01|
|requests|2023-11-01|"[>=2.3.0,<2.31.0]"|CVE-2023-32681|5|2023-12-01|
|requests|2023-11-01|[<=0.13.1]|PVE-2023-99936|0|2023-12-01|
|requests|2023-10-01|[<2.3.0]|CVE-2014-1829|26|2023-11-01|
|requests|2023-11-01|[<2.3.0]|CVE-2014-1829|27|2023-12-01|
|requests|2023-10-01|[<=2.19.1]|CVE-2018-18074|26|2023-11-01|
|requests|2023-11-01|[<=2.19.1]|CVE-2018-18074|27|2023-12-01|
|requests|2023-10-01|[<2.3.0]|CVE-2014-1830|26|2023-11-01|

We can see that `CVE-2015-2296` has been known about for a while, with 26 previous commits as of November 2023 (27 in December). `CVE-2023-32681` is much newer, and `PVE-2023-99936` has no previous commit. That will turn out to be important for those pesky numbers...

## Why Not External Tables?

I did consider dropping the JSON files into Cloud Storage and laying an external table over them, which would have allowed me to do more within DBT.

I would still have needed to do something custom to interact with GitHub, and I would have still needed to figure out which commits I'd already seen and filter them out. It didn't seem worth introducing DBT-plus-a-package to the process I already had working so I left it be.

## Gotcha - BigQuery Sandbox Partition Expiration

After looking at options to merge a commit safely and efficiently into the target table, I settled on [partitioning the target table by date](https://github.com/brabster/pypi_vulnerabilities/blob/64812282d8c94d32a769723fdb99da3b2a97d861/etl/safety_db/bigquery.py#L3) and [overwriting the partition with WRITE_TRUNCATE](https://github.com/brabster/pypi_vulnerabilities/blob/64812282d8c94d32a769723fdb99da3b2a97d861/etl/safety_db/bigquery.py#L45) when I upload a given commit. Even if I do end up re-running any upload, I won't end up with duplicates to worry about.

That approach works just great - except when you're running in the BigQuery sandbox and partition expiration is automatically set to 60 days - that's 60 days from the partition timestamp, not the wall clock time when you write the data. Confused me for a while - I was sure what I was doing should work but somehow I only seemed to get the last couple of partitions showing up!

## Cutting my Losses with the Sandbox

At this point, knowing I was about to tackle the multi-Terabyte PyPI downloads dataset I decided to cut my losses and move to a billed account. To avoid a hard break, I left the original work in account `pypi-vulnerabilities` but relocated new work to `pypi-vulns`, which runs in my Tempered Works-attributed account, with billing set up.

The BigQuery sandbox is an awesome capability, but it's time to get serious and pay actual money.

## Next Time

How I dealt with that large PyPI dataset history without bankrupting myself.
