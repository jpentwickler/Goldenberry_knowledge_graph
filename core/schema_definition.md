# Business Model Canvas + JTBD Schema Definition with Semantic Enhancement

## Overview
This document provides the complete schema definition for the Business Model Canvas enhanced with Jobs-to-be-Done (JTBD) theory in Neo4j graph databases. **Each node contains research-based semantic descriptions from authoritative business literature**, including Alexander Osterwalder's Business Model Canvas, Clayton Christensen's Jobs-to-be-Done Theory, and Anthony Ulwick's Outcome-Driven Innovation methodology.

## Semantic Enhancement Architecture

### Three-Layer Semantic Information Structure
Each node contains:
- **📚 Semantic Description**: Authoritative definitions from business literature
- **📖 Theoretical Foundation**: Academic research background and citations  
- **🎯 Practical Application**: Implementation categories and success frameworks

### Authoritative Sources Integrated
- **Alexander Osterwalder & Yves Pigneur**: Business Model Canvas (2005-2010)
- **Clayton Christensen**: Jobs-to-be-Done Theory (Harvard Business School)
- **Anthony Ulwick**: Outcome-Driven Innovation (Strategyn, 1990-present)
- **Philip Kotler**: Innovation management validation
- **Harvard Business Review**: Peer-reviewed business research

## Node Types (12 entities)

### 1. BusinessModel
**Central entity representing the complete business model**

```cypher
CREATE (bm:BusinessModel {
    id: "STRING", // KEY - Unique identifier for the business model
    name: "STRING", // Name of the business model
    description: "STRING", // Description of the business model
    createdDate: date("YYYY-MM-DD"), // Date when the business model was created
    lastModified: date("YYYY-MM-DD"), // Date when the business model was last modified
    
    // Semantic Enhancement Properties
    semanticDescription: "STRING", // A strategic management template used for developing new business models and documenting existing ones. It offers a visual chart with elements describing a firm's or product's value proposition, infrastructure, customers, and finances, assisting businesses to align their activities by illustrating potential trade-offs. (Osterwalder & Pigneur)
    theoreticalFoundation: "STRING", // Based on Alexander Osterwalder and Yves Pigneur's Business Model Canvas framework, co-created with 470 practitioners from 45 countries. The canvas consists of nine building blocks that describe value proposition, infrastructure, customers, and finances.
    purpose: "STRING" // To help companies move beyond product-centric thinking towards business model thinking, enabling structured conversations around new businesses or existing ones for strategic management and innovation.
})
```

**Research Citations**: 
- Osterwalder, A., & Pigneur, Y. (2010). Business Model Generation
- Harvard Business Review applications by leading companies (GE, P&G, Nestlé)
- 9 building blocks framework validated by 470 practitioners from 45 countries

### 2. ValueProposition
**The bundle of products and services that create value for customers**

```cypher
CREATE (vp:ValueProposition {
    id: "STRING", // KEY - Unique identifier for the value proposition
    title: "STRING", // Title of the value proposition
    description: "STRING", // Detailed description of the value proposition
    
    // Semantic Enhancement Properties
    semanticDescription: "STRING", // The collection of products and services a business offers to meet the needs of its customers. According to Osterwalder, a company's value proposition is what distinguishes it from its competitors. It provides value through various elements such as newness, performance, customization, getting the job done, design, brand/status, price, cost reduction, risk reduction, accessibility, and convenience/usability.
    theoreticalFoundation: "STRING", // Central element of Osterwalder's Business Model Canvas, representing the unique combination of products and services that create value for specific customer segments. The value proposition is at the center of the canvas, connecting customer-facing and infrastructure elements.
    valueElements: "STRING" // Provides value through: newness, performance improvement, customization, job completion, superior design, brand/status, competitive pricing, cost reduction, risk mitigation, improved accessibility, enhanced convenience and usability.
})
```

**Research Citations**:
- Osterwalder Business Model Canvas central element theory
- Value creation mechanisms from Business Model Generation methodology
- Competitive differentiation framework from strategic management literature

### 3. CustomerSegment
**The different groups of people or organizations an enterprise aims to reach and serve**

```cypher
CREATE (cs:CustomerSegment {
    id: "STRING", // KEY - Unique identifier for the customer segment
    name: "STRING", // Name of the customer segment
    description: "STRING", // Description of the customer segment
    
    // Semantic Enhancement Properties
    semanticDescription: "STRING", // The different groups of people or organizations an enterprise aims to reach and serve. To build an effective business model, a company must identify which customers it tries to serve. Various sets of customers can be segmented based on their different needs and attributes to ensure appropriate implementation of corporate strategy.
    theoreticalFoundation: "STRING", // One of nine building blocks in Osterwalder's Business Model Canvas. Customer segments can include mass market, niche market, segmented, diversified, and multi-sided platforms, each requiring tailored value propositions and relationship strategies.
    segmentationApproach: "STRING" // Segments are defined based on different needs, attributes, and jobs-to-be-done, enabling companies to tailor their value propositions and business model elements to specific customer groups.
})
```

**Research Citations**:
- Osterwalder & Pigneur customer segmentation methodology
- Market segmentation theory from Business Model Canvas framework
- Customer-centric business model design principles

### 4. JobExecutor (JTBD)
**The person who executes the job with three types: core job executor, product lifecycle support team, and buyer**

```cypher
CREATE (je:JobExecutor {
    id: "STRING", // KEY - Unique identifier for the job executor
    name: "STRING", // Name of the job executor type
    executorType: "STRING", // Type: core job executor, product lifecycle support team, buyer
    roleTitle: "STRING", // The person's identity in their organization or task
    industryDomain: "STRING", // The professional context they work in
    environment: "STRING", // Physical or digital setting in which they perform the job
    experienceLevel: "STRING", // Level of expertise with the type of job or domain
    executionFrequency: "STRING", // How often they perform jobs relevant to your study
    authorityInfluence: "STRING", // Degree of control over tools, methods, or decisions
    dependencyStructure: "STRING", // Whether they work solo, in teams, under supervision, etc.
    constraintsLimitations: "STRING", // Factors that restrict their ability to perform the job
    toolsSystemsUsed: "STRING", // Common tools, systems, or workarounds employed
    informationBehavior: "STRING", // How they gather and validate information
    demographics: "STRING", // Age, location, education — only when directly relevant
    
    // Semantic Enhancement Properties
    semanticDescription: "STRING", // The individual or role responsible for executing a specific job-to-be-done. In ODI methodology, job executors are the people who actually perform the core functional job, and understanding their context, constraints, and capabilities is crucial for developing solutions that fit their execution environment.
    theoreticalFoundation: "STRING", // Based on Anthony Ulwick's Outcome-Driven Innovation framework and Tony Ulwick's Jobs-to-be-Done theory. The job executor concept recognizes that understanding WHO performs the job is as important as understanding the job itself, as their context directly influences solution requirements.
    odiRelevance: "STRING" // Critical for ODI process as job executors define the execution context, constraints, and success metrics. Their characteristics directly influence what constitutes an effective solution and how outcomes should be measured.
})
```

**Research Citations**:
- Anthony Ulwick's Outcome-Driven Innovation methodology (Strategyn, 1990-present)
- Job executor context framework from ODI process
- Philip Kotler's validation: "Ulwick is the Deming of Innovation"

### 5. JobToBeDone (JTBD)
**The functional job that the job executor is trying to accomplish**

```cypher
CREATE (job:JobToBeDone {
    id: "STRING", // KEY - Unique identifier for the job to be done
    jobStatement: "STRING", // The clear, concise phrasing in form: Verb + Object + Context
    jobType: "STRING", // Classification: Functional, Emotional, Social or Related
    contextOfExecution: "STRING", // Clarifies when or where the job is typically performed
    jobCategory: "STRING", // Thematic or domain grouping for organizational purposes
    frequency: "STRING", // How often this job is typically performed
    priorityLevel: "STRING", // Perceived importance to the job executor
    
    // Semantic Enhancement Properties
    semanticDescription: "STRING", // A job-to-be-done is a fundamental unit of analysis that describes what customers are trying to accomplish in a given situation. As Clayton Christensen states: 'Customers don't buy products; they pull them into their life to make progress.' A job describes the progress that a customer is trying to make in a particular circumstance.
    theoreticalFoundation: "STRING", // Originally conceptualized by Tony Ulwick in 1990 and later popularized by Clayton Christensen. Based on the premise that people buy products and services to get jobs done. The theory provides a framework for categorizing, defining, capturing, and organizing customer needs tied to the job-to-be-done.
    odiFramework: "STRING", // In Ulwick's ODI framework, jobs include: (i) core functional job-to-be-done, (ii) desired outcomes tied to the core functional job, (iii) related jobs, (iv) emotional and social jobs, (v) consumption chain jobs, and (vi) buyer's financial desired outcomes.
    stabilityCharacteristic: "STRING" // A properly defined functional job-to-be-done is stable over time - it doesn't change. What changes is the solution or technology used to get the job done. This stability makes jobs a reliable foundation for innovation strategy.
})
```

**Research Citations**:
- Clayton Christensen (Harvard Business School): "The Innovator's Solution" (2003)
- Anthony Ulwick: "Jobs to be Done: Theory to Practice" (2016)
- Theodore Levitt's foundational insight: "People don't want a quarter-inch drill, they want a quarter-inch hole"

### 6. Channel
**How a company communicates with and reaches its customer segments to deliver value propositions**

```cypher
CREATE (ch:Channel {
    id: "STRING", // KEY - Unique identifier for the channel
    name: "STRING", // Name of the channel
    channelType: "STRING", // Type of channel (acquisition, delivery, retention)
    medium: "STRING", // Channel medium (digital, physical, hybrid)
    ownership: "STRING", // Channel ownership (owned, partner, hybrid)
    
    // Semantic Enhancement Properties
    semanticDescription: "STRING", // Communication and distribution pathways through which an organization reaches its customer segments to deliver value propositions. Channels serve several functions including raising awareness, helping customers evaluate value propositions, allowing purchase, delivering value propositions, and providing post-purchase customer support.
    theoreticalFoundation: "STRING", // Part of Osterwalder's Business Model Canvas framework. Channels can be direct (sales force, web sales) or indirect (own stores, partner stores, wholesaler). They vary in terms of revenue potential, cost, and level of integration with business model.
    channelFunctions: "STRING" // Channels serve multiple functions: awareness (how do we raise awareness about our products and services?), evaluation (how do we help customers evaluate our value proposition?), purchase (how do customers purchase our products?), delivery (how do we deliver our value proposition?), after sales (how do we provide post-purchase customer support?).
})
```

**Research Citations**:
- Business Model Canvas channel strategy framework
- Multi-channel distribution theory from strategic management
- Customer journey integration methodology

### 7. CustomerRelationship
**The types of relationships a company establishes with specific customer segments**

```cypher
CREATE (cr:CustomerRelationship {
    id: "STRING", // KEY - Unique identifier for the customer relationship
    type: "STRING", // Type of relationship (personal, automated, self-service, community)
    purpose: "STRING", // Purpose of the relationship (acquisition, retention, boosting sales)
    description: "STRING", // Description of the customer relationship
    
    // Semantic Enhancement Properties
    semanticDescription: "STRING", // The types of relationships a company establishes with specific customer segments. Customer relationships can range from personal to automated, and are driven by customer acquisition, customer retention, and boosting sales motivations. Each customer segment has specific relationship expectations.
    theoreticalFoundation: "STRING", // Component of Osterwalder's Business Model Canvas focusing on relationship management strategy. Different customer segments expect different types of relationships, from high-touch personal assistance to efficient self-service platforms.
    relationshipTypes: "STRING" // Categories include: Personal assistance (human interaction during sales and after), Dedicated personal assistance (dedicated customer representatives), Self-service (companies maintain no direct relationship), Automated services (automated processes), Communities (user communities facilitate connections), Co-creation (companies engage customers in value creation).
})
```

**Research Citations**:
- Customer relationship management theory from Business Model Canvas
- Relationship marketing principles from academic literature
- Customer experience design methodology

### 8. RevenueStream
**The cash a company generates from each customer segment**

```cypher
CREATE (rs:RevenueStream {
    id: "STRING", // KEY - Unique identifier for the revenue stream
    name: "STRING", // Name of the revenue stream
    type: "STRING", // Type of revenue (one-time, recurring)
    pricingMechanism: "STRING", // Pricing mechanism (fixed, dynamic, market-based)
    amount: FLOAT, // Revenue amount
    frequency: "STRING", // Frequency of revenue generation
    
    // Semantic Enhancement Properties
    semanticDescription: "STRING", // The cash a company generates from each customer segment. Revenue streams represent the arteries of a business model and answer the question: For what value is each customer segment truly willing to pay? Revenue can be generated through various mechanisms including asset sales, usage fees, subscription fees, lending/renting/leasing, licensing, brokerage fees, and advertising.
    theoreticalFoundation: "STRING", // Core component of Osterwalder's Business Model Canvas representing the financial viability element. Revenue streams can have different pricing mechanisms including fixed list prices, bargaining, auctioning, market dependent, volume dependent, or yield management.
    revenueTypes: "STRING" // Revenue generation methods: Asset sale (selling ownership rights), Usage fee (pay-per-use), Subscription fees (selling continuous access), Lending/Renting/Leasing (temporarily granting exclusive rights), Licensing (granting permission to use protected intellectual property), Brokerage fees (intermediation services), Advertising (advertising space fees).
})
```

**Research Citations**:
- Revenue model taxonomy from Business Model Canvas framework
- Pricing strategy theory from financial management literature  
- Business model monetization research

### 9. KeyResource
**The most important assets required to make a business model work**

```cypher
CREATE (kr:KeyResource {
    id: "STRING", // KEY - Unique identifier for the key resource
    name: "STRING", // Name of the key resource
    type: "STRING", // Type of resource (physical, intellectual, human, financial)
    description: "STRING", // Description of the key resource
    ownership: "STRING", // Ownership status (owned, leased, partner)
    
    // Semantic Enhancement Properties
    semanticDescription: "STRING", // The most important assets required to make a business model work. Key resources allow an enterprise to create and offer a value proposition, reach markets, maintain relationships with customer segments, and earn revenues. Different business models require different key resources, which can be owned, leased, or acquired from partners.
    theoreticalFoundation: "STRING", // Essential building block of Osterwalder's Business Model Canvas representing the asset foundation. Resources can be physical (manufacturing facilities, buildings, vehicles, machines, systems), intellectual (brands, proprietary knowledge, patents, copyrights, partnerships, customer databases), human (talented individuals, particularly in knowledge-intensive and creative industries), or financial (cash, lines of credit, stock option pools).
    resourceCategories: "STRING" // Physical resources (manufacturing facilities, buildings, vehicles, machines, systems, point-of-sales systems, distribution networks), Intellectual resources (brands, proprietary knowledge, patents and copyrights, partnerships, customer databases), Human resources (creative industries and knowledge-intensive industries require talented people), Financial resources (cash, lines of credit, stock option pools for hiring key employees).
})
```

**Research Citations**:
- Resource-based view of the firm from strategic management theory
- Key resource classification from Business Model Canvas methodology
- Asset optimization principles from operations management

### 10. KeyActivity
**The most important things a company must do to make its business model work**

```cypher
CREATE (ka:KeyActivity {
    id: "STRING", // KEY - Unique identifier for the key activity
    name: "STRING", // Name of the key activity
    type: "STRING", // Type of activity (production, problem-solving, platform/network)
    description: "STRING", // Description of the key activity
    priority: "STRING", // Priority level of the activity
    
    // Semantic Enhancement Properties
    semanticDescription: "STRING", // The most important things a company must do to make its business model work. Key activities are the critical actions a company must take to operate successfully. These activities are required to create and offer a value proposition, reach markets, maintain customer relationships, and earn revenues.
    theoreticalFoundation: "STRING", // Core building block of Osterwalder's Business Model Canvas representing operational requirements. Activities vary based on business model type and can be categorized as production activities (designing, making, and delivering products), problem-solving activities (developing new solutions to individual customer problems), or platform/network activities (managing platforms, networks, and matchmaking software).
    activityCategories: "STRING" // Production activities (designing, making, and delivering a product in substantial quantities and/or of superior quality - dominant in manufacturing firms), Problem solving (new knowledge-intensive activities such as consulting, hospitals, training - developing solutions to individual customer problems), Platform/Network activities (software platforms, networks, brands as platforms - managing platforms as key activities).
})
```

**Research Citations**:
- Value chain analysis from Michael Porter's strategic framework
- Core competency theory integrated with Business Model Canvas
- Operations strategy principles from management literature

### 11. KeyPartnership
**The network of suppliers and partners that make the business model work**

```cypher
CREATE (kp:KeyPartnership {
    id: "STRING", // KEY - Unique identifier for the key partnership
    partnerName: "STRING", // Name of the partner
    type: "STRING", // Type of partnership (strategic alliance, joint venture, supplier relationship)
    motivation: "STRING", // Motivation for the partnership
    description: "STRING", // Description of the partnership
    value: FLOAT, // Value of the partnership
    
    // Semantic Enhancement Properties
    semanticDescription: "STRING", // The network of suppliers and partners that make the business model work. Companies create alliances to optimize their business models, reduce risk, or acquire resources. Partnerships are becoming a cornerstone of many business models as companies seek to focus on their core activities while leveraging partners for non-core capabilities.
    theoreticalFoundation: "STRING", // Strategic building block of Osterwalder's Business Model Canvas representing external relationship management. Partnerships can be motivated by optimization and economy of scale (buyer-supplier relationships to optimize allocation of resources), reduction of risk and uncertainty (strategic alliances in uncertain environments), or acquisition of particular resources and activities (access to licenses, knowledge, customers).
    partnershipTypes: "STRING" // Strategic alliances between non-competitors (partnerships between companies in different industries or between competitors in specific market segments), Coopetition (strategic partnerships between competitors), Joint ventures (developing new business opportunities), Buyer-supplier relationships (ensuring reliable supplies and optimizing supply chains).
})
```

**Research Citations**:
- Strategic alliance theory from organizational management
- Partnership strategy framework from Business Model Canvas
- Collaborative business model research from academic literature

### 12. CostStructure
**All costs incurred to operate a business model**

```cypher
CREATE (cost:CostStructure {
    id: "STRING", // KEY - Unique identifier for the cost structure
    name: "STRING", // Name of the cost category
    type: "STRING", // Type of cost (fixed, variable)
    category: "STRING", // Category of cost (operational, marketing, infrastructure)
    amount: FLOAT, // Cost amount
    frequency: "STRING", // Frequency of the cost
    
    // Semantic Enhancement Properties
    semanticDescription: "STRING", // All costs incurred to operate a business model. Cost structure describes the most important costs incurred while operating under a particular business model. Creating and delivering value, maintaining customer relationships, and generating revenue all incur costs. Business models can be cost-driven (focused on minimizing costs) or value-driven (focused on value creation).
    theoreticalFoundation: "STRING", // Financial foundation element of Osterwalder's Business Model Canvas representing expense management. Costs can be calculated relatively easily after defining key resources, key activities, and key partnerships. Some business models are more cost-driven than others, with cost structures having fixed costs, variable costs, economies of scale, and economies of scope characteristics.
    costTypes: "STRING" // Fixed costs (costs that remain the same despite volume of goods or services produced - salaries, rents, facilities), Variable costs (costs that vary proportionally with volume of goods or services produced), Economies of scale (cost advantages obtained with increased output), Economies of scope (cost advantages from larger scope of operations - same marketing activities for multiple products).
})
```

**Research Citations**:
- Cost management theory from managerial accounting
- Business model cost optimization from strategic management
- Financial structure analysis from Business Model Canvas framework

## Relationship Types (15 relationships)

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
(CustomerSegment)-[:DEFINED_BY_JOB_EXECUTOR]->(JobExecutor)
// No properties
```

#### 5. DEFINED_BY_JOB
```cypher
(CustomerSegment)-[:DEFINED_BY_JOB]->(JobToBeDone)
// No properties
```

#### 6. EXECUTES_JOB
```cypher
(JobExecutor)-[:EXECUTES_JOB]->(JobToBeDone)
// No properties
```

#### 7. ADDRESSES_JOB
```cypher
(ValueProposition)-[:ADDRESSES_JOB]->(JobToBeDone)
// No properties
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
(CustomerSegment)-[:GENERATES]->(RevenueStream)
// No properties
```

### Resource and Activity Dependencies

#### 11. REQUIRES_RESOURCE
```cypher
(ValueProposition)-[:REQUIRES_RESOURCE]->(KeyResource)
// No properties
```

#### 12. REQUIRES_ACTIVITY
```cypher
(ValueProposition)-[:REQUIRES_ACTIVITY]->(KeyActivity)
// No properties
```

#### 13. USES_RESOURCE
```cypher
(KeyActivity)-[:USES_RESOURCE]->(KeyResource)
// No properties
```

### Partnership Relationships

#### 14. ENABLES
```cypher
(KeyPartnership)-[:ENABLES]->(KeyResource)
// No properties
```

#### 15. SUPPORTS
```cypher
(KeyPartnership)-[:SUPPORTS]->(KeyActivity)
// No properties
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

#### Job Executor Types
- `"core job executor"` - Primary job performers
- `"product lifecycle support team"` - Supporting team members
- `"buyer"` - Decision makers and purchasers

#### Job Types
- `"Functional"` - Primary functional jobs
- `"Emotional"` - Jobs related to feelings and emotions
- `"Social"` - Jobs related to social perception and status
- `"Related"` - Adjacent or supporting jobs

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
- **15+ relationship types** must be represented
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
- Leverage semantic descriptions for stakeholder education and strategic analysis

This schema enables comprehensive business model analysis combining strategic Business Model Canvas insights with customer-centric Jobs-to-be-Done theory, enhanced with authoritative semantic knowledge from leading business research.
