# Debugging Rules Checklist
## 1. Understand the System
- Read the manual. It'll tell you to lubricate the trimmer head on your weed whacker so that the lines don't fuse together.
- Read everything in depth. The section about the interrupt getting to your microcomputer is buried on page 37.
- Know the fundamentals. Chain saws are supposed to be loud.
- Know the road map. Engine speed can be different from tire speed, and the difference is in the transmission.  
- Understand your tools. Know which end of the thermometer is which, and how to use the fancy features on your Glitch−O−Matic logic analyzer.  
- Look up the details. Even Einstein looked up the details. Kneejerk, on the other hand, trusted his memory.
## 2. Make it Fail
- Do it again. Do it again so you can look at it, so you can focus on the cause, and so you can tell if you fixed it.
- Start at the beginning. The mechanic needs to know that the car went through the car wash before the windows froze.
- Stimulate the failure. Spray a hose on that leaky window.  
- But don't simulate the failure. Spray a hose on the leaky window, not on a different, "similar" one.  
- Find the uncontrolled condition that makes it intermittent. Vary everything you can—shake it, rattle it, roll it, and twist it until it shouts.  
- Record everything and find the signature of intermittent bugs. Our bonding system always and only failed on jumbled calls.  
- Don't trust statistics too much. The bonding problem seemed to be related to the time of day, but it was actually the local teenagers tying up the phone lines.  
- Know that "that" can happen. Even the ice cream flavor can matter.
- Never throw away a debugging tool. A robot paddle might come in handy someday.• Do it again. Do it again so you can look at it, so you can focus on the cause, and so you can tell if you fixed it.
- Start at the beginning. The mechanic needs to know that the car went through the car wash before the windows froze.
- Stimulate the failure. Spray a hose on that leaky window.  
- But don't simulate the failure. Spray a hose on the leaky window, not on a different,  "similar" one.  
- Find the uncontrolled condition that makes it intermittent. Vary everything you can—shake it, rattle it, roll it, and twist it until it shouts.  
- Record everything and find the signature of intermittent bugs. Our bonding system  always and only failed on jumbled calls.  
- Don't trust statistics too much. The bonding problem seemed to be related to the time of day, but it was actually the local teenagers tying up the phone lines.  
- Know that "that" can happen. Even the ice cream flavor can matter.  
- Never throw away a debugging tool. A robot paddle might come in handy someday.
## 3. Quit Thinking and Look
- See the failure. The senior engineer saw the real failure and was able to find the cause. The junior guys thought they knew what the failure was and fixed something that wasn't broken.
- See the details. Don't stop when you hear the pump. Go down to the basement and find out which pump.
- Build instrumentation in. Use source code debuggers, debug logs, status messages, flashing lights, and rotten egg odors.
- Add instrumentation on. Use analyzers, scopes, meters, metal detectors, electrocardiography machines, and soap bubbles.
- Don't be afraid to dive in. So it's production software. It's broken, and you'll have to open it up to fix it.
- Watch out for Heisenberg. Don't let your instruments overwhelm your system.  
- Guess only to focus the search. Go ahead and guess that the memory timing is bad, but look at it before you build a timing fixer.
## 4. Divide and Conquer
- Narrow the search with successive approximation. Guess a number from 1 to 100, in seven guesses.
- Get the range. If the number is 135 and you think the range is 1 to 100, you'll have to widen the range.
- Determine which side of the bug you are on. If there's goo, the pipe is upstream. If there's no goo, the pipe is downstream.
- Use easy−to−spot test patterns. Start with clean, clear water so the goo is obvious when it enters the stream.
- Start with the bad. There are too many good parts to verify. Start where it's broken and work your way back up to the cause.
- Fix the bugs you know about. Bugs defend and hide one another. Take 'em out as soon as you find 'em.
- Fix the noise first. Watch for stuff that you know will make the rest of the system go crazy. But don't get carried away on marginal problems or aesthetic changes.
## 5. Change One Thing at a Time
- Isolate the key factor. Don't change the watering schedule if you're looking for the effect of the sunlight.
- Grab the brass bar with both hands. If you try to fix the nuke without knowing what's wrong first, you may have an underwater Chernobyl on your hands.
- Change one test at a time. I knew my VGA capture phase was broken because nothing else was changing.
- Compare it with a good one. If the bad ones all have something that the good ones don't, you're onto the problem.
- Determine what you changed since the last time it worked. My friend had changed the cartridge on the turntable, so that was a good place to start.
## 6. Keep an Audit Trail
- Write down what you did, in what order, and what happened as a result. When did you last drink coffee? When did the headache start?
- Understand that any detail could be the important one. It had to be a plaid shirt to crash the video chip.
- Correlate events. "It made a noise for four seconds starting at 21:04:53" is better than "It made a noise."
- Understand that audit trails for design are also good for testing. Software configuration control tools can tell you which revision introduced the bug.
- Write it down! No matter how horrible the moment, make a memorandum of it.
## 7. Check the Plug
- Start at the beginning - every time. Did you initialize memory properly? Did you squeeze the primer bulb? Did you turn it on?
- Question your assumptions. Are you running the right code? Are you out of gas? Is it plugged in?
- Test the tooling. Are you running the right compiler? Is the fuel gauge stuck? Does the meter have a dead battery?
## 8. Get a Fresh View
- Ask for fresh insights. Even a dummy can help you see something you didn't see before.  
- Tap expertise. Only the VGA capture vendor could confirm that the phase function was broken.  
- Listen to the voice of experience. It will tell you the dome light wire gets pinched all the time.  
- Know that help is all around you. Coworkers, vendors, the Web, and the bookstore are waiting for you to ask.  
- Don't be proud. Bugs happen. Take pride in getting rid of them, not in getting rid of them by yourself.  
- Report symptoms, not theories. Don't drag a crowd into your rut.  
- Realize that you don't have to be sure. Mention that the shirt was plaid.
# 9. IYDFIIAF: If You Didn't Fix It, It Ain't Fixed
- Check that it's really fixed. Don't assume that it was the wires and send that dirty fuel filter back onto the road.
- Check that it's really your fix that fixed it. "Wubba!" might not be the thing that did the trick.
- Know that it never just goes away by itself. Make it come back by using the original Make It Fail methods. If you have to ship it, ship it with a trap to catch it when it happens in the field.
-Fix the cause. Tear out the useless eight−track deck before you burn out another transformer.
- Fix the process. Don't settle for just cleaning up the oil. Fix the way you design machines.