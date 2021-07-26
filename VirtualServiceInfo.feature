Feature: Display Virtual Service information

    Scenario Outline: Single service
        Given Virtual Service URL preview duration of 30 minutes
        And Extended Visibility duration of 120 minutes
        And services lasting 60 minutes
        And a service is created named <Name>, starting <StartOffsetMinutes> minutes <FromNowOrAgo>, <WithOrWithoutVirtualServiceUrl> a virtual service URL
        When the FUSW is computed
        Then its DisplayAsUpcomingService is <DisplayAsUpcomingService>
        And its UpcomingStatus is <UpcomingStatus>
        And the service is <ServiceIsVisible> in the FUSW
        And the Virtual Service URL is <VirtualServiceUrlIsVisible> in the FUSW
        Examples:
            | Name                                   | StartOffsetMinutes | FromNowOrAgo | WithOrWithoutVirtualServiceUrl | DisplayAsUpcomingService | UpcomingStatus    | ServiceIsVisible | VirtualServiceUrlIsVisible |
            | Upcoming Service                       | 60                 | from now     | with                           | true                     | Upcoming          | true             | false                      |
            | Upcoming Service without URL           | 60                 | from now     | with                           | false                    | Upcoming          | true             | false                      |
            | Preview Service                        | 15                 | from now     | with                           | true                     | Imminent          | true             | true                       |
            | Preview Service without URL            | 15                 | from now     | with                           | false                    | Imminent          | true             | false                      |
            | Ongoing Service                        | 15                 | ago          | with                           | true                     | Ongoing           | true             | true                       |
            | Ongoing Service without URL            | 15                 | ago          | with                           | true                     | Ongoing           | true             | true                       |
            | Recently Completed Service             | 75                 | ago          | with                           | true                     | RecentlyCompleted | true             | false                      |
            | Recently Completed Service without URL | 75                 | ago          | with                           | true                     | RecentlyCompleted | true             | false                      |
            | Long Completed Service                 | 240                | ago          | with                           | false                    | n/a               | false            | false                      |
            | Long Completed Service without URL     | 240                | ago          | with                           | false                    | n/a               | false            | false                      |


    Scenario Outline: One prior service and one succeeding service
        Given Virtual Service URL preview duration of 30 minutes
        And Extended Visibility duration of 120 minutes
        And service durations of 60 minutes
        And example is <ExampleName>
        And a prior service is created, starting <PriorStartOffset> minutes <PriorFromNowOrAgo>
        And a succeeding service is created, starting <SucceedingStartOffset> minutes from now
        When the FUSW is computed
        Then the prior service DisplayAsUpcomingService is <PriorDisplayAsUpcomingService>
        And the prior service UpcomingStatus is <PriorUpcomingStatus>
        And the prior service is <PriorServiceIsVisible> in the FUSW
        And the succeeding service DisplayAsUpcomingService is <SucceedingDisplayAsUpcomingService>
        And the succeeding service UpcomingStatus is <SucceedingUpcomingStatus>
        And the succeeding service is <SucceedingServiceIsVisible> in the FUSW
        Examples:
            | ExampleName                                   | PriorStartOffset | PriorFromNowOrAgo | SucceedingStartOffset | PriorDisplayAsUpcomingService | PriorUpcomingStatus | PriorServiceIsVisible | SucceedingDisplayAsUpcomingService | SucceedingUpcomingStatus | SucceedingServiceIsVisible |
            | Prior Ongoing                                 | 10               | ago               | 10,000                | true                          | Ongoing             | true                  | false                              | n/a                      | false                      |
            | Prior Recently Completed                      | 75               | ago               | 10,000                | true                          | Recently Completed  | true                  | false                              | n/a                      | false                      |
            | Prior Long Completed, Next Upcoming in a week | 240              | ago               | 10,000                | false                         | n/a                 | false                 | true                               | Upcoming                 | true                       |
            | Prior last week, Next Upcoming                | 10,000           | ago               | 240                   | false                         | n/a                 | false                 | true                               | Upcoming                 | true                       |
            | Next Imminent                                 | 10,000           | ago               | 10                    | false                         | n/a                 | false                 | true                               | Imminent                 | true                       |

    Scenario Outline: Report overlapping visibility periods for
        Given Virtual Service URL preview duration of <PreviewMinutes> minutes
        And Extended Visibility duration of <ExtendedVisibilityMinutes> minutes
        And service durations of <DurationMinutes> minutes
        And example is <ExampleName>
        And a prior service is created named "Prior Service", starting 5 minutes ago
        When a next service is created, starting <NextServiceOffset> minutes later
        Then an overlap is <OverlapReported> for the next service with "Prior Service"
        Examples:
            | ExampleName                      | DurationMinutes | ExtendedVisibilityMinutes | PreviewMinutes | NextServiceOffset | OverlapReported |
            | No overlap, prior featured       | 20              | 20                        | 20             | 90                | not reported    |
            | Overlap, extended vs. preview    | 20              | 20                        | 20             | 45                | reported        |
            | Overlap, extended vs. start      | 20              | 20                        | 0              | 30                | reported        |
            | Overlap, ongoing vs. preview     | 20              | 0                         | 20             | 30                | reported        |
            | Overlap, ongoing vs. start       | 20              | 0                         | 0              | 10                | reported        |
            | Overlap but both already started | 20              | 0                         | 0              | 1                 | not reported    |