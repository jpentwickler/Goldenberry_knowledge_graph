# Business Model Canvas + JTBD Schema Definition

## Overview
This document provides the complete schema definition for the Business Model Canvas enhanced with Jobs-to-be-Done (JTBD) theory in Neo4j graph databases.

## Node Types (12 entities)

### 1. BusinessModel
**Central entity representing the complete business model**

```cypher
CREATE (bm:BusinessModel {
    id: "STRING", // KEY - Unique identifier for the business model
    name: "STRING", // Name of the business model
    description: "STRING", // Description of the business model
    createdDate: date("YYYY-MM-DD"), // Date when the business model was created
    lastModified: date("YYYY-MM-DD") // Date when the business model was last modified
})
```

### 2. ValueProposition
**The bundle of products and services that create value for customers**

```cypher
CREATE (vp:ValueProposition {
    id: "STRING", // KEY - Unique identifier for the value proposition
    title: "STRING", // Title of the value proposition
    description: "STRING", // Detailed description of the value proposition
    painReliever: "STRING", // How this value proposition relieves customer pains
    gainCreator: "STRING" // How this value proposition creates customer gains
})
```

### 3. CustomerSegment
**The different groups of people or organizations an enterprise aims to reach and serve**

```cypher
CREATE (cs:CustomerSegment {
    id: "STRING", // KEY - Unique identifier for the customer segment
    name: "STRING", // Name of the customer segment
    description: "STRING", // Description of the customer segment
    demographics: "STRING", // Demographic characteristics of the segment
    psychographics: "STRING", // Psychographic characteristics of the segment
    size: INTEGER // Estimated size of the customer segment
})
```

### 4. JobExecutor (JTBD)
**The person who executes the job (following ODI methodology)**

```cypher
CREATE (je:JobExecutor {
    id: "STRING", // KEY - Unique identifier for the job executor
    name: "STRING", // Name of the job executor type
    description: "STRING", // Description of the job executor
    context: "STRING", // Context in which the job executor operates
    constraints: "STRING", // Constraints faced by the job executor
    capabilities: "STRING", // Capabilities of the job executor
    motivations: "STRING" // Primary motivations of the job executor
})
```

### 5. JobToBeDone (JTBD)
**The functional job that the job executor is trying to accomplish**

```cypher
CREATE (job:JobToBeDone {
    id: "STRING", // KEY - Unique identifier for the job to be done
    jobStatement: "STRING", // The core job statement following ODI format
    functionalAspect: "STRING", // The functional dimension of the job
    emotionalAspect: "STRING", // The emotional dimension of the job
    socialAspect: "STRING", // The social dimension of the job
    jobType: "STRING", // Type of job (core, related, emotional, consumption)
    frequency: "STRING", // How often the job needs to be done
    importance: FLOAT, // Importance rating of the job (1-10)
    satisfaction: FLOAT, // Current satisfaction level with existing solutions (1-10)
    opportunity: FLOAT // Opportunity score calculated from importance and satisfaction
})
```

### 6. Channel
**How a company communicates with and reaches its customer segments to deliver value propositions**

```cypher
CREATE (ch:Channel {
    id: "STRING", // KEY - Unique identifier for the channel
    name: "STRING", // Name of the channel
    channelType: "STRING", // Type of channel (acquisition, delivery, retention)
    medium: "STRING", // Channel medium (digital, physical, hybrid)
    ownership: "STRING", // Channel ownership (owned, partner, hybrid)
    cost: FLOAT, // Cost associated with the channel
    efficiency: FLOAT, // Efficiency rating of the channel
    reach: INTEGER // Potential reach of the channel
})
```

### 7. CustomerRelationship
**The types of relationships a company establishes with specific customer segments**

```cypher
CREATE (cr:CustomerRelationship {
    id: "STRING", // KEY - Unique identifier for the customer relationship
    type: "STRING", // Type of relationship (personal, automated, self-service, community)
    purpose: "STRING", // Purpose of the relationship (acquisition, retention, boosting sales)
    description: "STRING", // Description of the customer relationship
    cost: FLOAT // Cost of maintaining the relationship
})
```

### 8. RevenueStream
**The cash a company generates from each customer segment**

```cypher
CREATE (rs:RevenueStream {
    id: "STRING", // KEY - Unique identifier for the revenue stream
    name: "STRING", // Name of the revenue stream
    type: "STRING", // Type of revenue (one-time, recurring)
    pricingMechanism: "STRING", // Pricing mechanism (fixed, dynamic, market-based)
    amount: FLOAT, // Revenue amount
    frequency: "STRING" // Frequency of revenue generation
})
```

### 9. KeyResource
**The most important assets required to make a business model work**

```cypher
CREATE (kr:KeyResource {
    id: "STRING", // KEY - Unique identifier for the key resource
    name: "STRING", // Name of the key resource
    type: "STRING", // Type of resource (physical, intellectual, human, financial)
    description: "STRING", // Description of the key resource
    ownership: "STRING", // Ownership status (owned, leased, partner)
    cost: FLOAT // Cost of the resource
})
```

### 10. KeyActivity
**The most important things a company must do to make its business model work**

```cypher
CREATE (ka:KeyActivity {
    id: "STRING", // KEY - Unique identifier for the key activity
    name: "STRING", // Name of the key activity
    type: "STRING", // Type of activity (production, problem-solving, platform/network)
    description: "STRING", // Description of the key activity
    priority: "STRING", // Priority level of the activity
    cost: FLOAT // Cost of the activity
})
```

### 11. KeyPartnership
**The network of suppliers and partners that make the business model work**

```cypher
CREATE (kp:KeyPartnership {
    id: "STRING", // KEY - Unique identifier for the key partnership
    partnerName: "STRING", // Name of the partner
    type: "STRING", // Type of partnership (strategic alliance, joint venture, supplier relationship)
    motivation: "STRING", // Motivation for the partnership
    description: "STRING", // Description of the partnership
    value: FLOAT // Value of the partnership
})
```

### 12. CostStructure
**All costs incurred to operate a business model**

```cypher
CREATE (cost:CostStructure {
    id: "STRING", // KEY - Unique identifier for the cost structure
    name: "STRING", // Name of the cost category
    type: "STRING", // Type of cost (fixed, variable)
    category: "STRING", // Category of cost (operational, marketing, infrastructure)
    amount: FLOAT, // Cost amount
    frequency: "STRING" // Frequency of the cost
})
```

## Relationship Types (17 relationships)

### Core Business Model Relationships

#### 1. HAS_VALUE_PROPOSITION
```cypher
(BusinessModel)-[:HAS_VALUE_PROPOSITION]->(ValueProposition)
// No properties
```

#### 2. HAS_CUSTOMER_SEGMENT  
```cypher
(BusinessModel)-[:HAS_CUSTOMER_SEGMENT]->(CustomerSegment)
// No properties
```

#### 3. TARGETS
```cypher
(ValueProposition)-[:TARGETS]->(CustomerSegment)
// No properties
```

### JTBD Integration Relationships

#### 4. DEFINED_BY_JOB_EXECUTOR
```cypher
(CustomerSegment)-[:DEFINED_BY_JOB_EXECUTOR {
    segmentFit: "STRING" // How well this job executor fits the customer segment
}]->(JobExecutor)
```

#### 5. DEFINED_BY_JOB
```cypher
(CustomerSegment)-[:DEFINED_BY_JOB {
    jobPriority: "STRING" // Priority of this job for the customer segment
}]->(JobToBeDone)
```

#### 6. EXECUTES_JOB
```cypher
(JobExecutor)-[:EXECUTES_JOB {
    executionContext: "STRING", // Context in which the job executor performs the job
    executionFrequency: "STRING" // How often this executor performs this job
}]->(JobToBeDone)
```

#### 7. ADDRESSES_JOB
```cypher
(ValueProposition)-[:ADDRESSES_JOB {
    jobSolutionFit: "STRING" // How well the value proposition addresses the job
}]->(JobToBeDone)
```

### Traditional Canvas Relationships

#### 8. REACHES_THROUGH
```cypher
(CustomerSegment)-[:REACHES_THROUGH]->(Channel)
// No properties
```

#### 9. HAS_RELATIONSHIP_WITH
```cypher
(CustomerSegment)-[:HAS_RELATIONSHIP_WITH]->(CustomerRelationship)
// No properties
```

#### 10. GENERATES
```cypher
(CustomerSegment)-[:GENERATES {
    contribution: FLOAT // Revenue contribution from this segment
}]->(RevenueStream)
```

### Resource and Activity Dependencies

#### 11. REQUIRES_RESOURCE
```cypher
(ValueProposition)-[:REQUIRES_RESOURCE {
    dependency: "STRING" // Level of dependency on this resource
}]->(KeyResource)
```

#### 12. REQUIRES_ACTIVITY
```cypher
(ValueProposition)-[:REQUIRES_ACTIVITY {
    criticality: "STRING" // Criticality of this activity for the value proposition
}]->(KeyActivity)
```

#### 13. USES_RESOURCE
```cypher
(KeyActivity)-[:USES_RESOURCE {
    usage: "STRING" // How the resource is used in the activity
}]->(KeyResource)
```

### Partnership Relationships

#### 14. ENABLES
```cypher
(KeyPartnership)-[:ENABLES {
    accessType: "STRING" // Type of access provided by the partnership
}]->(KeyResource)
```

#### 15. SUPPORTS
```cypher
(KeyPartnership)-[:SUPPORTS {
    supportLevel: "STRING" // Level of support provided
}]->(KeyActivity)
```

### Cost Relationships

#### 16. INCURS_COST (Resources)
```cypher
(KeyResource)-[:INCURS_COST {
    costDriver: "STRING" // What drives the cost relationship
}]->(CostStructure)
```

#### 17. INCURS_COST (Activities)
```cypher
(KeyActivity)-[:INCURS_COST {
    costDriver: "STRING" // What drives the cost relationship
}]->(CostStructure)
```

#### 18. INCURS_COST (Channels)
```cypher
(Channel)-[:INCURS_COST {
    costDriver: "STRING" // What drives the cost relationship
}]->(CostStructure)
```

## Property Data Types

### Standard Data Types
- **STRING**: Text values, use quotes in Cypher
- **INTEGER**: Whole numbers (e.g., 1000, 25000)
- **FLOAT**: Decimal numbers (e.g., 9.5, 1250.75)
- **DATE**: Neo4j date format using `date("YYYY-MM-DD")`

### Enumerated Values

#### Channel Types
- `"acquisition"` - Channels for attracting new customers
- `"delivery"` - Channels for delivering value to customers  
- `"retention"` - Channels for retaining existing customers

#### Job Types
- `"core"` - Primary functional jobs
- `"related"` - Adjacent or supporting jobs
- `"emotional"` - Jobs related to feelings
- `"consumption"` - Jobs in the consumption chain

#### Resource Types  
- `"physical"` - Physical assets and infrastructure
- `"intellectual"` - IP, algorithms, brands, databases
- `"human"` - People, teams, networks
- `"financial"` - Cash, credit lines, stock options

#### Activity Types
- `"production"` - Creating and manufacturing activities
- `"problem-solving"` - Consulting, training, analysis activities  
- `"platform/network"` - Managing platforms and networks

#### Partnership Types
- `"strategic alliance"` - Strategic partnerships between non-competitors
- `"joint venture"` - Joint business ventures
- `"supplier relationship"` - Reliable supplier relationships

#### Cost Types
- `"fixed"` - Costs that remain constant regardless of output
- `"variable"` - Costs that vary with output or activity level

#### Cost Categories  
- `"operational"` - Day-to-day operational costs
- `"marketing"` - Sales and marketing expenses
- `"infrastructure"` - Technology and infrastructure costs

#### Revenue Types
- `"one-time"` - Single transaction revenues
- `"recurring"` - Subscription or repeat revenues

#### Pricing Mechanisms
- `"fixed"` - Fixed pricing model
- `"dynamic"` - Dynamic or variable pricing
- `"market-based"` - Market-driven pricing

#### Relationship Types (Customer)
- `"personal"` - Personal assistance and dedicated service
- `"automated"` - Automated services and self-service
- `"self-service"` - Customer self-service models
- `"community"` - User communities and co-creation

## Validation Rules

### Required Relationships
- Every CustomerSegment must have at least one JobExecutor and one JobToBeDone
- Every ValueProposition must address at least one JobToBeDone  
- Every business model must have at least one of each channel type (acquisition, delivery, retention)
- All costs must be attributed to at least one source (resource, activity, or channel)

### Schema Completeness
- **12 node types** must be present
- **17+ relationship types** must be represented
- **3 channel types** must be included
- **JTBD integration** must be complete for all customer segments

### Data Quality
- All nodes must have unique IDs
- All monetary values should be positive
- Ratings should be on appropriate scales (1-10 for importance/satisfaction)
- Dates should use proper Neo4j date format

## Usage Notes

- Always create constraints before adding data
- Use meaningful IDs with prefixes (e.g., "bm_001", "vp_001")
- Ensure every relationship type is represented in your business model
- Include all three channel types for comprehensive channel strategy
- Link all costs to their appropriate drivers
- Use realistic business scenarios that demonstrate JTBD principles

This schema enables comprehensive business model analysis combining strategic Business Model Canvas insights with customer-centric Jobs-to-be-Done theory.