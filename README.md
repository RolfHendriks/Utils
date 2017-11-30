# Utils
Utilities for common iOS development tasks

This repository serves as a distilled collection of those general purpose iOS development utilities that I have found the most useful. Examples include:

- Enabling concise autolayout code such as: [parent addMargins:UIEdgeInsetsZero toSubview:child];
- Concise frame layout code such as: view.top = otherView.bottom + 10;
- Concise CGAffineTransform manipulation such as: self.translation = CGPointMake(0, 10);
- Safe NSDictionary read + write operations
- easy monospaced digit fonts for buttons or labels that change numeric values frequently
- etc

Only features that should be useful for every app should be included in these utilities. Minimal size and complexity is a key differentiator for this library.

Another key design point for this library is to stick with building simple UIKit utilities, not inventing new APIs. For example, all Autolayout utilities are of the form 'add...Constraint', thus mimicking UIKit's language for dealing with constraints.

Combining multiple UIKit extensions into a single file is deliberate. The nature of all of these utilities is that they save a small amount of work, but save work very frequently. If these various category extensions were instead each written as their own separate file, then the overhead of importing the correct files/dependencies would arguably outweigh the benefit of having these utilities.

The choice of Objective C instead of Swift is mostly historic. Many of these utilities were originally developed as early as iOS2. Stability is also a key concern because I use these utils in almost every project.
