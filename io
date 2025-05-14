Great questions. Let’s break them down clearly:

---

## 🔹 What Does “Evicted Pages” Mean in MongoDB (WiredTiger)?

### ➤ **Evicted pages** refer to memory pages that **WiredTiger removes from its internal cache** to make room for newer data.

MongoDB uses a **cache** (WiredTiger cache) to store recently used documents, indexes, and internal structures. When the cache becomes full, older or less-used pages are **evicted** (pushed out of memory).

Think of it like:

> “My cache is full, I need to kick out some older stuff to make space for newer queries.”

---

### 🔹 Types of Evictions

1. **Clean Evictions**

   * Pages that haven't been modified and can be discarded directly.

2. **Dirty Evictions**

   * Pages that **have been modified**, and must be **written to disk** before eviction.

Too many dirty evictions may indicate **disk I/O pressure or write-heavy load**.

---

## 🔍 Metrics to Monitor Memory Pressure in MongoDB

You can use `db.serverStatus()` to check WiredTiger cache-related metrics.

### 🔸 Check Cache Pressure

Run this:

```js
db.serverStatus().wiredTiger.cache
```

Look for:

| Metric                                                      | Meaning                             | Red Flag                       |
| ----------------------------------------------------------- | ----------------------------------- | ------------------------------ |
| `tracked dirty bytes in the cache`                          | Dirty data not yet flushed to disk  | High = Write pressure          |
| `bytes currently in the cache`                              | Current usage of WiredTiger cache   | Near limit = cache full        |
| `maximum bytes configured`                                  | Total cache limit                   | For comparison                 |
| `pages evicted because they exceeded the in-memory maximum` | How many pages are forcibly evicted | High = pressure                |
| `pages queued for eviction`                                 | Pages waiting to be evicted         | Should be low                  |
| `unmodified pages evicted`                                  | Clean pages evicted                 | Expected                       |
| `modified pages evicted`                                    | Dirty pages evicted                 | If high = write I/O bottleneck |

---

### 🔸 Check Overall Memory and Swap Pressure

Run:

```js
db.serverStatus().mem
```

Key fields:

| Field               | Meaning                           | Red Flag                          |
| ------------------- | --------------------------------- | --------------------------------- |
| `resident`          | Memory used by mongod in RAM (MB) | Close to total RAM = tight memory |
| `virtual`           | Total virtual memory used         | Very high = possible memory leaks |
| `mapped`            | Data files memory-mapped          | Usually stable                    |
| `mappedWithJournal` | Includes journaling               | Stable unless under I/O pressure  |

Also, on **Linux**, run:

```bash
vmstat 5
```

Look for:

* `si` and `so`: swap-in/swap-out. If non-zero often, you're swapping — BAD.
* `free` and `buff/cache`: low free and low buffer/cache can indicate memory pressure.

---

## 🔍 Optional: Enable More Visibility with FTDC Metrics (MongoDB Diagnostic Data)

MongoDB automatically collects internal stats with **FTDC** — for more granular tracking.

Tools like:

* **mongostat**
* **mongotop**
* **Atlas monitoring** (if using Atlas)
* **Percona Monitoring and Management (PMM)**

Can give dashboards for memory/cache pressure.

---

## ✅ Summary: Signs of Memory Pressure

| Signal                                                           | Interpretation                              |
| ---------------------------------------------------------------- | ------------------------------------------- |
| High `pages evicted because they exceeded the in-memory maximum` | Cache full, frequent eviction               |
| High `dirty pages` with slow `flush`                             | Disk I/O bottleneck                         |
| High swap usage (check `vmstat`)                                 | OS under memory pressure                    |
| Resident memory ≈ system RAM                                     | OS may start swapping                       |
| Increasing query latency                                         | Could be due to cache misses and disk reads |

---

Let me know your system specs or `serverStatus()` output — I can help analyze it directly.
