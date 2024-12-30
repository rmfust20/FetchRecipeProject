### Steps to Run the App
1. Clone the respository
2. Open the project in Xcode
3. With Xcode open select the Product drop down
4. To run the app click Product -> Run
5. To test the app click Product -> Test

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?

During my time with this project I focused largely on architecture and scalability. I wanted this project to reflect how I would approach a larger scale application, and thus I chose to adopt the MVVM pattern even though it was a bit overkill for this smaller app. 

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?

I spent about 10 hours working on this project. I reconginze this is a bit longer than the reccomended time, but I spent a large portion of time studying best practices for MVVM and handling network requests. Other than that I spent a decent amount of time trying to decide on the best way to implement the cache. I wanted to prioritize speed, but also didn't want to use to much memory or fall into risky use of state variables.

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?

As mentioned earlier the cache is where I felt I had to compromise the most. Ideally I would have liked to only store data in the cache and use as few network calls as possible. This didn't seem possible to me so I instead opted for a speed based approach where the app first looks in the cache for images, making network calls when needed.

### Weakest Part of the Project: What do you think is the weakest part of your project?

I think the weakest part of the project is the layout of the image generation in the recipe view list. If another developer were to read this section I think it would be hard to follow the logic as there are many nested if statements.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.

I'd be very interested to learn the optimal approach to the cache as the solution I landed on seems to sacrifice too much memory.
