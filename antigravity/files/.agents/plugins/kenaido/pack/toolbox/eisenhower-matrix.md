# The Eisenhower matrix

## What it is

A two-by-two grid for sorting a list of work by two separate questions: **is it urgent** (it loses value or causes harm if it waits) and **is it important** (it moves the goal forward or protects something that matters). Each of the four boxes says what to do with its items.

| | **Urgent** | **Not urgent** |
|---|---|---|
| **Important** | **Do it now.** A defect hurting users today, a deadline that cannot move | **Plan it.** Most of the valuable work lives here: quality, prevention, the next capability |
| **Less important** | **Keep it small, or hand it on.** Interruptions and requests that feel pressing but move little | **Drop it, or leave it at the bottom.** Work nobody would miss |

The technique is widely known under this name, which comes from a US president to whom the idea of separating the urgent from the important is commonly attributed. The attribution is not verified here (`ANLY-2`). The name is used only because it is the technique's common name, and the description above is our own (`COMM-4`).

**Why two questions and not one.** The main point of the tool is that urgency and importance are different things. What is urgent gets attention by itself. The tool exists to protect the important work that is not urgent, which is where problems are prevented and value is built, and which is the first thing pushed aside under pressure.

## When to use it

- A backlog review, or triaging a pile of findings, where everything seems to need doing at once.
- A day or a Sprint where interruptions are crowding out the planned work.
- Explaining to a person why an item that feels pressing is not being done first.
- Checking a plan for balance: if nearly everything sits in "do it now", the team is firefighting, and the "plan it" box needs time reserved.

## When not to use it

- **To set the order of a Product Backlog.** The order belongs to the Product Owner, weighing value, risk, cost, and dependencies (`TEAM-1`). The matrix is an input to that order, not a replacement for it.
- **To rank items inside one box.** It says nothing about which of two urgent, important items comes first; use value and dependencies, or the [vital, essential, extra](vital-essential-extra.md) tool when some items rest on others.
- **When items depend on each other.** Two boxes cannot show that one item has to be finished before another; order by dependency first.
- **For a list of one or two items**, or an order a person has already set. The grid adds nothing there.
- **As an excuse to drop quality work.** Tests, security, and documentation usually look "not urgent"; they are important, so they go in "plan it", never in "drop it" (`TEST-1`, `CODE-9`).

## How to run it

1. **Name the goal the list serves.** "Important" means important for that goal; without it, the sort becomes a matter of taste.
2. **Agree on what "urgent" means here,** in time: for example, harm or lost value if it waits past this Sprint. Write it down, so everyone sorts the same way.
3. **Sort each item by both questions, one at a time,** with a short reason for each answer. A security defect in released work is urgent and important; a message that could be clearer is usually neither.
4. **Act per box:**
   - **Do it now:** pull it into the current or next piece of work.
   - **Plan it:** give it a place in the order, and protect time for it.
   - **Keep it small, or hand it on:** do the smallest version, batch it, or pass it to the role that owns it.
   - **Drop it, or leave it at the bottom:** say so openly, so nobody waits for it.
5. **Check the balance.** Many items in "do it now" is a warning about how the work is being run, not only a list to clear (`FLOW-5`).
6. **Record the grid with the work it served,** for example in the Sprint Planning record or the backlog review, and name the tool (`ANLY-10`). A person decides what is done with it (`PRIN-2`).

## What it produces

A grid with each item in one box and a one-line reason. The real output is the list in "plan it", the important work that would otherwise lose to whatever is urgent, and any item whose urgency turned out to be only noise.

## Common mistakes

- **Treating urgent as important.** An item someone is waiting for is not, for that reason alone, worth doing.
- **An empty "plan it" box.** Either the list holds only reactions, or the important work was sorted by how loud it is.
- **Putting everything in "do it now".** The grid then says nothing; sharpen what "urgent" means, or split the list.
- **Letting the grid decide.** It sorts; the Product Owner orders and a person decides (`PRIN-2`, `TEAM-1`).

## Rules applied

`ANLY-2`, `ANLY-10`, `CODE-9`, `COMM-4`, `FLOW-5`, `PRIN-2`, `TEAM-1`, `TEST-1`.
