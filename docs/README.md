# Features

Feature extraction with MOOC-Learner-Quantified requires:
- A MySQL database containing the MOOC course's data in the `MOOCdb` format.
- The start date of the MOOC course.
- The number of weeks of the MOOC course.
- The list of features to be extracted (check the information available in the database beforehand)

## List of Features

| Feature ID | Name | Default value | Dependencies | Description |
|-----------:|:----:|:-------------:|:------------:|:-----------:|
| 1 |dropout |0 |[] |Whether or not the student has dropped out by this week (this is the label used in prediction). |
| 2 |Observed events |0 |[10] |Total time spent on each resource during the week. |
| 3 |num Forum post |0 |[103] |Number of forum posts during the week. |
| 4 |num Wiki edits |0 |[104] |Number of wiki edits during the week. |
| 5 |avg length forum post |0 |[105] |Average length of forum posts during the week. |
| 6 |num distinct attempts |0 |[11, 111] |Number of distinct problems attempted during the week. |
| 7 |num attempts |0 |[209] |Number of potentially non-distinct problem attempts during the week. |
| 8 |num distinct problem correct |0 |[10, 11, 110, 111] |Number of distinct problems correct during the week. |
| 9 |avg attempts per problem |0 |[109, 202, 203] |Average number of problem attempts during the week. |
| 10 |observed events per correct problems |-1 |[110] |Total time spent on all resources during the week (feat. 2) divided by number of correct problems (feat. 8). |
| 11 |problems attempted per correct problem |-1 |[111] |Number of problems attempted (feat. 6) divided by number of correct problems (feat. 8). |
| 12 |avg time to solve problem |-1 |[112] |Average of (max(attempt.timestamp) - min(attempt.timestamp)) for each problem during the week. |
| 13 |variance of observed events time |0 |[] |Variance of a students observed event timestamps in one week. |
| 14 |num collaborations |0 |[] |Number of collaborations during the week. |
| 15 |max duration evnts |0 |[] |Duration of longest observed event |
| 16 |observed events on lectures |0 |[] |Total time spent on all lecture-related resources during the week. |
| 17 |observed events on books |0 |[] |Total time spent on all book-related resources during the week. |
| 18 |observed events on wiki |0 |[] |Total time spent on all wiki-related resources during the week. |
| 103 |difference feature 3 |0 |[] |Number of forum posts in current week divided by number of forum posts in previous week (difference of feature 3). |
| 104 |difference feature 4 |0 |[] |Number of wiki edits in current week divided by number of wiki edits in previous week (difference of feature 4). |
| 105 |difference feature 5 |0 |[] |Average length of forum posts in current week divided by average length of forum posts in previous week, where number of forum posts in previous week is > 5 (difference of feature 5). |
| 109 |difference feature 9 |0 |[] |Average number of attempts in current week divided by average number of attempts in previous week (difference of feature 9). |
| 110 |difference feature 10 |0 |[] |(Total time spent on all resources during current week (feat. 2) divided by number of correct problems during current week (feat. 8)) divided by same thing from previous week (difference of feature 10). |
| 111 |difference feature 11 |0 |[] |(Number of problems attempted (feat. 6) divided by number of correct problems (feat. 8)) divided by same thing from previous week (difference of feature 11). |
| 112 |difference feature 12 |0 |[] |(Average of (max(attempt.timestamp) - min(attempt.timestamp)) for each problem during current week) divided by same thing from previous week (difference of feature 12). |
| 201 |number of forum responses |0 |[] |Number of forum responses per week (also known as CF1). |
| 202 |percentile of average number of attempts |0 |[] |Each students average number of attempts during the week (feat. 9) compared with other students as a percentile. |
| 203 |percent of average number of attempts |0 |[] |Each students average number of attempts during the week (feat. 9) compared with other students as a percent of max. |
| 204 |pset grade |0 |[205] |Number of homework problems correct in a week divided by number of homework problems in the week. |
| 205 |pset grade over time |-1 |[] |Pset grade from current week (feature 204) - avg(pset grade from previous week). |
| 206 |lab grade |0 |[207] |Number of lab problems correct in a week divided by number of lab problems in the week. |
| 207 |lab grade over time |0 |[] |Lab grade from current week (feature 206) - avg(lab grade from previous week). |
| 208 |attempts correct |-1 |[209] |Number of attempts (any type) that were correct during the week. |
| 209 |percent correct submissions |0 |[] |Percentage of total submissions that were correct (feature 208 / feature 7). |
| 210 |average predeadline submission time |-1 |[] |Average time between problem submissions and problem due date (in seconds). |
| 301 |std hours working |0 |[] |Standard deviation of the hours the user produces events and collaborations. Tries to capture how regular a student is with her schedule while doing a MOOC. |
| 302 |time to react |0 |[] |Average time in days a student takes to react when a new resource in posted. Tried to capture how fast a student is reacting to new content. |

## Video Watching Features 

We implement 65 features, where 2 of them are describing dropouts, 48
of them are video watching features extracted from the click-stream
logs, and the rest 15 of them are extracted from the course
tables for characterizing course content and verification.

| feature\_id | feature\_table |feature\_name | feature\_description |
|------------:|:--------------:|:------------:|:--------------------:|
1 | user\_long\_feature | dropout | Whether or not the student has not dropped out by this week (this is the label used in dropout prediction) | 
701 | user\_feature | user\_dropout\_week | The dropout week of a user | 
711 | user\_long\_feature | number\_of\_videos\_per\_user\_per\_week | The number of distinct videos that a user has watched in a week | 
712 | video\_feature | number\_of\_users\_per\_video | The number of distinct users that watch a specific video | 
713 | user\_feature | number\_of\_videos\_per\_user | The number of distinct videos that a user has watched | 
714 | long\_feature | number\_of\_videos\_per\_week | The number of videos that has been watched by users in a week | 
721 | user\_long\_feature | total\_engagement\_time\_per\_user\_per\_week | Total engagement time of a user in a week | 
722 | video\_feature | total\_engagement\_time\_per\_video | Total engagement time on a video | 
723 | user\_feature | total\_engagement\_time\_per\_user | Total engagement time of a user | 
724 | long\_feature | total\_engagement\_time\_per\_week | Total engagement time in a week | 
731 | user\_long\_feature | session\_engagement\_time\_per\_user\_per\_week | Average engagement time of a watching session of a user in a week | 
732 | video\_feature | session\_engagement\_time\_per\_video | Average engagement time of a watching session of a video | 
733 | user\_feature | session\_engagement\_time\_per\_user | Average engagement time of a watching session of a user | 
734 | long\_feature | session\_engagement\_time\_per\_week | Average engagement time of a watching session in a week | 
741 | user\_long\_feature | completion\_rate\_casual\_per\_user\_per\_week | Percentage of videos that are completed over a certain threshold of a user in a week | 
742 | video\_feature | completion\_rate\_casual\_per\_video | Percentage of users that completed the video over a certain threshold of a video | 
743 | user\_feature | completion\_rate\_casual\_per\_user | Percentage of videos that are completed over a certain threshold of a user | 
744 | long\_feature | completion\_rate\_per\_week | Percentage of videos that are completed over a certain threshold in a week | 
751 | user\_long\_feature | watching\_frequency\_casual\_per\_user\_per\_week | The watching frequency counted by casual method of a user in a week | 
752 | video\_feature | watching\_frequency\_casual\_per\_video | The watching frequency counted by casual method of a week | 
753 | user\_feature | watching\_frequency\_casual\_per\_user | The watching frequency counted by casual method of a user | 
754 | long\_feature | watching\_frequency\_casual\_per\_week | The watching frequency counted by casual method in a week | 
755 | user\_long\_feature | watching\_frequency\_strict\_per\_user\_per\_week | The watching frequency counted by strict method of a user in a week | 
756 | video\_feature | watching\_frequency\_strict\_per\_video | The watching frequency counted by strict method of a week | 
757 | user\_feature | watching\_frequency\_strict\_per\_user | The watching frequency counted by strict method of a user | 
758 | long\_feature | watching\_frequency\_strict\_per\_week | The watching frequency counted by strict method in a week | 
761 | user\_long\_feature | seeking\_forward\_frequency\_per\_user\_per\_week | Seeking forward frequency of a user in a week | 
762 | video\_feature | seeking\_forward\_frequency\_per\_video | Seeking forward frequency of a video | 
763 | user\_feature | seeking\_forward\_frequency\_per\_user | Seeking forward frequency of a user | 
764 | long\_feature | seeking\_forward\_frequency\_per\_week | Seeking forward frequency in a week | 
765 | user\_long\_feature | seeking\_back\_frequency\_per\_user\_per\_week | Seeking back frequency of a user in a week | 
766 | video\_feature | seeking\_back\_frequency\_per\_video | Seeking back frequency of a video | 
767 | user\_feature | seeking\_back\_frequency\_per\_user | Seeking back frequency of a user | 
768 | long\_feature | seeking\_back\_frequency\_per\_week | Seeking back frequency in a week | 
771 | user\_long\_feature | pausing\_frequency\_per\_user\_per\_video | Pausing frequency of a user in a week | 
772 | video\_feature | pausing\_frequency\_per\_video | Pausing frequency of a video | 
773 | user\_feature | pausing\_frequency\_per\_user | Pausing frequency of a user | 
774 | long\_feature | pausing\_frequency\_per\_week | Pausing frequency in a week | 
781 | user\_long\_feature | total\_pausing\_time\_per\_user\_per\_week | Total pausing time of a user in a week | 
782 | video\_feature | total\_pausing\_time\_per\_video | Total pausing time of a video | 
783 | user\_feature | total\_pausing\_time\_per\_user | Total pausing time of a user | 
784 | long\_feature | total\_pausing\_time\_per\_week | Total pausing time in a week | 
791 | user\_long\_feature | average\_watching\_speed\_per\_user\_per\_week | Average watching speed of a user in a week | 
792 | video\_feature | average\_watching\_speed\_per\_video | Average watching speed of a video | 
793 | user\_feature | average\_watching\_speed\_per\_user | Average watching speed of a user | 
794 | long\_feature | average\_watching\_speed\_per\_week.sql | Average watching speed in a week | 
801 | user\_long\_feature | real\_watching\_time\_per\_user\_per\_week | Real watching time of a user in a week | 
802 | video\_feature | real\_watching\_time\_per\_video | Real watching time of a video | 
803 | user\_feature | real\_watching\_time\_per\_user | Real watching time of a user | 
804 | long\_feature | real\_watching\_time\_per\_week | Real watching time in a week | 
911 | video\_feature | video\_length\_per\_video | Length of a video | 
921 | video\_feature | watched\_frequency\_per\_video | Watching frequency of a video (for verification) | 
922 | video\_feature | viewed\_frequency\_per\_video | Viewing frequency of a video (for verification) | 
931 | user\_long\_feature | number\_of\_video\_per\_user\_per\_week | Number of distinct videos watched by a user in a week (for verification) | 
932 | user\_feature | number\_of\_video\_per\_user | Number of distinct videos watched by a user (for verification) | 
933 | long\_feature | number\_of\_video\_per\_week | Number of distinct videos watched in a week (for verification) | 
934 | user\_long\_feature | seeking\_frequency\_per\_user\_per\_week | Seeking frequency of a user in a week (for verification) | 
935 | user\_feature | seeking\_frequency\_per\_user | Seeking frequency of a user (for verification) | 
936 | long\_feature | seeking\_frequency\_per\_week | Seeking frequency in a week (for verification) | 
937 | user\_long\_feature | viewed\_frequency\_per\_user\_per\_week | Viewing frequency of a user in a week (for verification) | 
938 | user\_feature | viewed\_frequency\_per\_user | Viewing frequency of a user (for verification) | 
939 | long\_feature | viewed\_frequency\_per\_week | Viewing frequency in a week (for verification) | 
940 | user\_long\_feature | watched\_time\_per\_user\_per\_week | Watching time of a user in a week (for verification) | 
941 | user\_feature | watched\_time\_per\_user | Watching time of a user (for verification) | 
942 | long\_feature | watched\_time\_per\_week | Watching time in a week (for verification) | 

### Video Watching  Feature Design

We design 10 classes of video watching features, each captures a
specific characteristic of a user's watching behavior. Each class
includes a set of features, with different combinations of keys,
calculation methods, and parameters. The keys can be any subset of
user id, video id and week number. There could be $2^3=8$ features in
a class without any extra parameter and having only one calculation
method. We are interested in are these 4 types:

| Type | Keys | Used for | Table name |
|---------------------------:|:------------:|:-------------------------------------------------------------------:|:--------------------:|
| user longitudinal features | user & week |  dropout prediction                                                   | user\_long\_feature |
| user features              | user        | user-basis statistics & dropout classification                        | user\_feature |
| longitudinal features      | week        | user longitudinal behavior analyses                                   | long\_feature |
| video features             | video       | analyzing the correlations between video contents and user behavior   | video\_feature |

We call features of classes with summation aggregation methods as
cumulative features, and the opposite ones as characteristic features.
We always ignore null values when performing aggregations. And the
aggregation method \"logic or\" is always performed prior to any others
on the basic types since only basic type features could be booleans.

| No. | Class Name | Variations | Feature ids | Basic type definition | Basic type calculation methods | Parameters |
|----:|:----------:|:----------:|:-----------:|:---------------------:|:------------------------------:|:----------:|
|  1 | Is Watched | 8\*1\*1 |  711--714 |   Whether a user has ever watched a video in a week (Not Null) | Querying whether there are any click-stream logs of a user on a video | video: sum  week: or |
| 2 | Total engagement time | 8\*1\*1 | 721--724 |The total video time of a user on a video in a week (Not Null) | Summing up the video current time differences of a user on a video in a week, each of which is between a play-video or seek-video event and a subsequent pause-video, seek-video or load-video event |  video: sum   week: sum |
| 3 | Session engagement time | 8\*1\*1 | 731--734 | The average video time of a user on a video in a week in one watching session (Null if not watched) |Dividing the total engagement time by the number of sessions. Where the number of sessions here follows the strict method (see the watching frequency class below) |  video: average  week: average |
|  4 | Is Completed | 8\*2\*3 |   741--744 |   Whether a user has complete a video in a week (Null if not watched) |Casual completion: whether the user's total engagement time on the video in the week exceeds a threshold percentage (e.g. 80%) of video length. Strict completion: whether the percentage of evenly-divided fragments of the video that a user watched in the week exceeds a certain threshold (e.g. 80%)   com-pletion threshold: 80%, 90% or 95% |  video: average   week: average |
|  5 | Watching frequency | 8\*2\*1 |751--758| The number of watching sessions of a user on a video in a week (Not Null) | Casual session: the number of times that a user triggers non-contiguous load-video events on a video in a week. Strict session: the number of time gaps which are longer than 30 minutes in the click-stream of a user on a video in a week ordered by time-stamp |  video: sum  week: sum |
|  6 | Seeking frequency | 8\*2\*1 |   761--768 |   The number of times a user switch to a different point when watching a video in a week (Not Null) | Seeking forward: the number of seek-video events whose video new time is larger than video old time of a user on a video in a week. Seeking back: the opposite. Counting them separately since we expect that they may reflect different characteristics of watching behaviors |  video: sum   week: sum |
|  7 | Pausing frequency | 8\*1\*1 |   771--774 |   The number of times a user pause a video in a week (Not Null) | Counting the number of non-contiguous pause-video events of a user on a video in a week ordered by time-stamp |  video: sum  week: sum |
|  8 | Total pausing time | 8\*1\*1 |   781--784 |   The total real-world time that a user pause a video in a week (Not Null) | Summing up the time-stamp differences, each of which between a pause-video event and a subsequent play-video event |  video: sum  week: sum |
|  9 | Average watching speed |    8\*1\*1 |   791--794 |   The average watching speed of a user on a video in a week with engagement time as weight (Null if not watched) |   Calculating the weighted average watching speed by dividing the sum of products of unit engagement time and current video speed by the total engagement time |  video: average   week: average |
| 10 |Real watching time | 8\*1\*1 |  801--804 | The real-world watching time of a user on a video in a week | Summing up the quotients of unit engagement time and video speed |  video: sum  week: sum|



