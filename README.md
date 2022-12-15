# HyprRun
Codebase for HyprRun app. Built for 67-443 at CMU

# Project Description

You Set The Vibe 💥

We Curate Tracks For Your Run 🎧

You Crush Your Workout 💪



HyprRun makes running more enjoyable by playing music that changes with YOUR vibe! Like everything in life, we recognize that the pace or goals of your run are not constant. You may want to go faster during certain phases of your run, and slower during others. HyprRun attempts to recommend the track given your current 'vibe'. This means you no longer have to listen to calming classing music while you are attempting to hit a new 5K PR.

# Project Setup

1. Clone this repo 

2. Within XCode: 
   
   **_File -> Packages -> Resolve Package Versions_**

   If you are still reeiving warnings or errors: 

   **_File -> Packages -> Update to Latest Package Versions_**

3. Send Spotify Credentials to anyone on our team. This is required for our app to be able to personalize tracks and recommendations.

4. Build Application 

# Project Features

Interative development and extensive user research enabled us to implement the following features: 

- Authorization and Authentication via Spotify 🔐
- Select Specific Playlists From Your Library 🎶
  - Swipe or Tap to Select/Unselect
- Pick the Vibe of Your Run (Chill, Light, Determined, HYPR) 😎
  - Interactive Picker
- View Information Related to Your Music, Run, and Location All on One Page 🤩
  - To view live map, swipe on album image
  - Real time run analytics
- Play, Pause, or Skip Tracks As You Desire 🎧
- Adjust the Vibe Mid-Run and Receive Appropriate Recommendations 🤖
  - Using CoreML model built from a sci-kit learn model in Python. 
  - Trained on ~300 songs to understand what people deem to be a "hype" song
- Pause or End Run 🏃‍♀️
- View Summary Statistics for Your Run 🔢
- View All Past Runs on the Rewind Page ⏮
  - Additional information avaiable for each individual run

# Notes for Instructors

- Unit Testing
  - Due to the robust nature of the Spotify API, we decided to place our efforts elsewhere. Despite its steep learning curve, the Spotify API is really well tested and maintained. So, rather than dedicating valuable resources towards testing an established API, we worked on improving our machine learning classifier. 
  - We felt this was a valuable tradeoff because our users emphasized the need for their music to match the "vibe" of their run. We did not simply want to merge a running app with a music app. We wanted to merge the two and create something special, and that required us to move quicky and focus on the more novel aspects of our solution. Examples include fusing data from the Spotify API and Core Location.
  - We are really proud of the vast music and location functionalities we were able to provide to our users in such a short time. If we had prioritized unit testing well-established API end points we beleive we would not have been able to deliver this experience. 
- Features
  - We tried to capture all the features we mentioned in last phase. However, upon further conversation with users, we prioritized certain features over others. We also prioritized the overall design of our application so that it did not feel "cheap" or "raw". The features 

# A-Level Use Cases
- [x] Users Can Connect to their Spotify Account
- [x] Users Can View The Current Playing Track
- [x] Users Can Pause/Resume Their Music
- [x] Users can choose from all of their playlists which playlist  want to choose for each run
- [x] Users Can Start/Pause/End a Run
- [x] Users can view the duration (elapsed time of their run), their current average pace, and see the total distance they have ran
- [x] Users can view a run summary at the end of their run of the following attributes: Distance, Duration, and overall average pace
- [x] Users Can Adjust the ‘Vibe’ of the Music as they Run (while the user runs, the user can listen to songs that match the vibe of their song)

# B-Level Use Cases
- [x] Users can see their current running route as they run
- [x] Users can review end of run summary statistics for a specific past run 
- [x] Users can view a list of their prior run history grouped by month
- [ ] As part of their end of run summary, users can see how their music vibe levels change over time in relation to how their pace changes over time
   - After more user studies and performing a round of prioritization, we decided not to pursue this use case during this sprint because we considered it low priority. Users were not as interested in this ffeature as we originaly thought. Instead, we worked on improving our music recommendation algorihtm and cleaning up our user interface.

