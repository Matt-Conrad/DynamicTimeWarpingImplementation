# Dynamic Time Warping of Speech Segments

In this project, I explore Dynamic Time Warping (DTW) and apply it to speech segments to measure similarity between 2 speech segments. 

## Data

In the waveforms folder, there are 10 wav files: 5 files of the word "kiss" and 5 files of the word "love". These are said by different people and having different freqeuencies and timings.

## Explanation of each file

* SpeechRecognition.m: Provided 2 waveforms, this function that calculates the minimum cost between the two waveforms and the associated path
* TestScript.m: Simple test of the various functions in this project. The last test is for SpeechRecognition.m and it was used to calculate all of the waveform comparisons 
* DisplaySegment.m: Quick function to plot the waveform
* InsideParallelogram.m: Checks whether the point under consideration is inside Itakura's parallelogram
* Wave2Features.m: Converts the waveform to a feature vector
* StartEndFrames.mat: The manually found start and end points of each waveform

## Experiment & Results

I used the kiss1.wav as the reference waveform, then used SpeechRecognition.m to calculate the minimum cost between kiss1.wav and each of the other 9 speech segments. Additionally, the resulting costs were normalized by path length for better comparison between costs. The non-normalized and normalized costs can be found in the following table.

![Table](/Visuals/Table.png)

As you can see, the kiss1.wav and kiss3.wav are the most similar according to their normalized cost of 10.07. The corresponding path can be found in the following plot.

![OptimalPath](/Visuals/OptimalPath.png)

## Application

An area of application of this algorithm is something like your phone's voice assistant. In those products, a user can register their voice so that the assistant only responds to them. Dynamic Time Warping can be used to tell the difference between one person's voice and another with a common phrase ("Okay, Google" for example). 
