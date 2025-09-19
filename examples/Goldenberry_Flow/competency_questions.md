# Goldenberry Flow Knowledge Graph: Competency Questions

## Overview

This document outlines competency questions that an AI agent can answer when integrated with the Goldenberry Flow knowledge graph through the Neo4j MCP server. These questions demonstrate the analytical capabilities and business insights available from the graph database implementation.

## Integration Context

- **Knowledge Graph**: Goldenberry Flow Digital Trust Export Platform
- **Database**: Neo4j with complete business model implementation
- **MCP Integration**: Neo4j MCP server for AI agent connectivity
- **Schema**: Business Model Canvas + Jobs-to-be-Done framework with semantic enhancement

---

## Category 1: Business Model Structure & Validation

### Basic Structure Questions
1. **What are the core value propositions of the Goldenberry Flow business model?**
   - Expected: Digital Trust Investment Platform and Premium Exotic Fruit Export Operations

2. **How many customer segments does the business model serve and what are they?**
   - Expected: 2 segments - Digital Trust Investors and Premium Fruit Importers

3. **Which jobs-to-be-done does each customer segment have?**
   - Expected: Investors - "Maximize return on capital investment"; Importers - "Ensure consistent supply that meets supermarket standards"

4. **Are all customer segments properly integrated with JTBD methodology?**
   - Expected: Validation of complete JTBD integration with job executors and jobs for each segment

### Schema Validation Questions
5. **What are the 12 node types present in this business model and their counts?**
   - Expected: BusinessModel(1), ValueProposition(2), CustomerSegment(2), JobExecutor(2), JobToBeDone(2), Channel(28), CustomerRelationship(2), RevenueStream(3), KeyResource(5), KeyActivity(6), KeyPartnership(5), CostStructure(33)

6. **How many relationship types are implemented in the knowledge graph?**
   - Expected: 16 relationship types including HAS_VALUE_PROPOSITION, TARGETS, DEFINED_BY_JOB, EXECUTES_JOB, ADDRESSES_JOB, etc.

7. **Are all three channel types (acquisition, delivery, retention) covered?**
   - Expected: Confirmation of acquisition, delivery, and retention channel coverage across both customer segments

---

## Category 2: Customer Analysis & JTBD Integration

### Job Executor Analysis
8. **Who are the job executors for each customer segment?**
   - Expected: Investment Decision Maker (investors), Fruit Import Operations Manager (importers)

9. **What specific jobs do investors and importers need to accomplish?**
   - Expected: Detailed job statements with context and priority levels for each segment

10. **How do the value propositions address each job-to-be-done?**
    - Expected: Mapping showing Digital Trust Platform addresses capital return maximization, Export Operations addresses supply consistency

### JTBD Context Analysis
11. **What are the execution contexts and constraints for each job executor?**
    - Expected: Digital-first investment environment for investors, B2B commercial operations for importers

12. **Which value proposition targets which customer segment?**
    - Expected: Direct targeting relationships between specific value props and customer segments

---

## Category 3: Channel Strategy & Customer Relationships

### Channel Distribution
13. **What channels does each customer segment use for acquisition, delivery, and retention?**
    - Expected: Investors use LinkedIn campaigns, fintech conferences, digital platforms, automated systems; Importers use trade shows, container shipping, account management

14. **What types of relationships does the business maintain with each customer segment?**
    - Expected: Automated blockchain contracts for investors, personal transactional relationships for importers

15. **How many channels serve the investor segment vs. the importer segment?**
    - Expected: 13 channels for investors, 15 channels for importers

### Channel Strategy Analysis
16. **What is the channel strategy for reaching international fruit importers?**
    - Expected: Trade show participation, direct sales outreach, dedicated account management

17. **How does the digital trust platform serve as a delivery channel?**
    - Expected: Web-based investor portal for onboarding, documentation, and investment execution

---

## Category 4: Revenue & Financial Analysis

### Revenue Stream Analysis
18. **What are the revenue streams and their annual performance?**
    - Expected: Goldenberries Sales ($1,033,113.92), Pitahaya Sales ($1,163,569.71), Exotic Fruits Sales ($72,500.00) - total annual revenue $2,269,183.63

19. **What is the pricing model for each product in the revenue streams?**
    - Expected: Fixed kg-based pricing - Goldenberries: $7.00/kg, Pitahaya: $6.63/kg, Exotic Fruits: $5.00/kg (no monthly variations)

20. **How many cost categories and individual cost items exist in the business model?**
    - Expected: 6 major cost categories with 33 individual cost items total

21. **What are the main cost categories in the business model?**
    - Expected: Direct Product Costs, Export Operations Overhead, Digital Trust Infrastructure, Trust Administration & Governance, Financial Operations, Risk Management & Contingency

### Financial Performance Questions
22. **What are the revenue stream types and frequencies?**
    - Expected: All revenue streams are asset sale type with per-kg frequency and fixed pricing

23. **How are costs classified by type (fixed, variable, mixed)?**
    - Expected: 13 fixed costs, 17 variable costs, 3 mixed cost categories

### Time-Series Revenue Analysis
24. **What fiscal year does the revenue data cover in the knowledge graph?**
    - Expected: Fiscal Year 2025 (September 2024 - August 2025)

25. **How many monthly TimePeriod nodes exist in the graph and what do they represent?**
    - Expected: 12 TimePeriod nodes covering monthly periods with detailed temporal properties

26. **What are the monthly volume patterns for each product throughout the fiscal year?**
    - Expected: Goldenberries scaling from 0 kg to 24,695.95 kg peak; Pitahaya steady growth from 2,250.09 kg to 22,500 kg; Exotic Fruits seasonal pattern 0-3,000 kg

27. **Which product generates the highest total annual volume in kg?**
    - Expected: Pitahaya with 175,500.71 kg total, followed by Goldenberries with 147,587.70 kg

28. **What is the revenue calculation methodology stored in the knowledge graph?**
    - Expected: Volume(kg) × Price(USD/kg) = Monthly Revenue, aggregated across all periods

29. **How many VolumeData and PriceData nodes exist per product?**
    - Expected: 12 VolumeData nodes and 12 PriceData nodes per product (36 of each total)

30. **What is the peak monthly revenue period across all products?**
    - Expected: June-August 2025 period with maximum volumes for Goldenberries and Pitahaya

31. **How is the fixed pricing model represented in the graph structure?**
    - Expected: All PriceData nodes for each product have identical price values with zero volatilityIndex and marketAdjustment properties

### Product Performance Analysis
32. **What is the revenue per kg for each product and which is most profitable?**
    - Expected: All products have fixed profit margins - Pitahaya ($6.63/kg), Goldenberries ($7.00/kg), Exotic Fruits ($5.00/kg)

33. **How do monthly volumes progress for the highest-revenue product?**
    - Expected: Pitahaya shows consistent growth from 2,250.09 kg (Sep) to 22,500 kg (Jul-Aug), representing 10x volume scaling

34. **What is the relationship structure connecting revenue streams to time-series data?**
    - Expected: RevenueStream nodes connect to VolumeData and PriceData nodes, which connect to TimePeriod nodes and Product nodes

35. **How many total relationships exist in the time-series revenue model?**
    - Expected: 144+ relationships connecting revenue streams, products, volume data, price data, and time periods

---

## Category 5: Resource Dependencies & Operations

### Resource Requirements
23. **What key resources does each value proposition require?**
    - Expected: Digital Trust Platform requires blockchain infrastructure, legal framework, financial reserves, specialized team; Export Operations requires infrastructure and team

24. **Which activities are critical for delivering the digital trust investment platform?**
    - Expected: Digital Trust Asset Management, Investor Services & Transparency, Financial Operations & Compliance, Trust Operations Administration

25. **How do key activities utilize different key resources?**
    - Expected: Detailed mapping of activity-resource dependencies

### Resource Type Analysis
26. **What type of resources (physical, intellectual, human, financial) are most critical?**
    - Expected: Analysis showing intellectual resources (platform, legal framework) and human resources as most critical

27. **Which resources enable the export operations infrastructure?**
    - Expected: Local operating partners enable physical export infrastructure

---

## Category 6: Partnership Strategy & Ecosystem

### Partnership Value Analysis
28. **What are the key partnerships?**
    - Expected: Primary Operational Partner, Financial & Trust Infrastructure Partners, Technology & Platform Partners, Regulatory & Compliance Partners, Market & Customer Partners

29. **How do partnerships enable key resources and support key activities?**
    - Expected: Partnership-resource and partnership-activity relationship mappings

30. **How many strategic partnerships exist in the business model?**
    - Expected: 5 strategic partnerships across different categories

### Strategic Partnership Questions
31. **Which partnership enables primary operations?**
    - Expected: Primary Operational Partner for Colombian fruit operations and export infrastructure

32. **How does the Estonian legal framework partnership support regulatory compliance?**
    - Expected: Enables EU-compliant legal structure and supports regulatory compliance activities

---

## Category 7: Cost Attribution & Efficiency

### Cost Driver Analysis
33. **Which resources, activities, or channels have cost attribution relationships?**
    - Expected: 6 Key Resources, 13 Key Activities, and 7 Channels have INCURS_COST relationships

34. **What are the specific cost drivers for each major expense category?**
    - Expected: Detailed cost driver descriptions for each cost relationship

35. **What are the blockchain and digital infrastructure cost drivers?**
    - Expected: Platform complexity, smart contract deployment, transaction processing, AI integration, cybersecurity requirements

### Operational Cost Questions
36. **What personnel-related cost structures exist?**
    - Expected: Export Operations Personnel, Trust Operations Administrator (with specific cost drivers for team size, expertise, and operational scope)

37. **Which marketing channels incur the highest acquisition costs?**
    - Expected: Comparison of LinkedIn campaigns, conferences, and trade shows

---

## Category 8: Strategic Business Insights

### Competitive Analysis
38. **What makes this a dual-segment business model architecture?**
    - Expected: Analysis of serving both investors and importers with different value propositions

39. **How does blockchain technology create competitive advantage?**
    - Expected: Smart contract automation, transparency, trust, and compliance advantages

40. **What role does the Estonian regulatory framework play in the business model?**
    - Expected: EU market access, regulatory compliance, fiduciary protection benefits

### Scalability Questions
41. **How does the containerized export model support scalability?**
    - Expected: Container-based operations allow volume scaling and standardized logistics

42. **What are the key differentiators from traditional export businesses?**
    - Expected: Digital trust integration, blockchain governance, investor participation model

---

## Category 9: Risk & Compliance Analysis

### Risk Mitigation
43. **What regulatory compliance activities are required for this business model?**
    - Expected: Estonian framework compliance, blockchain regulations, international trade requirements

44. **How does the digital trust framework mitigate investment risks?**
    - Expected: Smart contracts, automated compliance, real-time transparency, fiduciary protection

45. **What quality assurance mechanisms protect importer relationships?**
    - Expected: Quality control facilities, certification processes, dedicated account management

### Compliance Framework
46. **Which partnerships reduce operational and regulatory risks?**
    - Expected: Estonian legal partners for compliance, local partners for operational risk reduction

47. **How does the legal structure provide fiduciary protection?**
    - Expected: Estonian legal framework with trust structure and regulatory oversight

---

## Category 10: Network Analysis & Relationships

### Graph Structure Analysis
48. **What is the complete network structure connecting business model components?**
    - Expected: Full business model network from BusinessModel through all relationships to end nodes

49. **Which nodes have the most relationship connections in the graph?**
    - Expected: Analysis of node centrality and connection density

50. **How are costs attributed throughout the business model network?**
    - Expected: Complete cost attribution network from sources to cost structures

### Relationship Pattern Analysis
51. **What is the relationship density between different node types?**
    - Expected: Statistical analysis of relationship patterns across node types

52. **Which components are most central to the business model's operation?**
    - Expected: Centrality analysis identifying critical components like specialized team, digital platform

---

## Usage Instructions for AI Agents

### Query Execution
- Use Neo4j Cypher queries through the MCP server to answer these questions
- Reference the validation queries in `validation_queries.cypher` for complex analyses
- Combine multiple simple queries for comprehensive answers

### Response Quality
- Provide specific data from the knowledge graph
- Include relevant context and business implications
- Reference node and relationship counts where applicable
- Cite specific property values and relationship details

### Business Context Integration
- Connect technical graph data to business strategy insights
- Explain the significance of dual-segment architecture
- Highlight blockchain and Estonian framework advantages
- Relate findings to Jobs-to-be-Done methodology

### Extended Analysis Capabilities
- Perform comparative analysis between customer segments
- Calculate financial ratios and business metrics
- Identify optimization opportunities in cost and resource allocation
- Assess strategic partnership value and dependencies

This competency question framework enables AI agents to provide comprehensive business intelligence and strategic insights from the Goldenberry Flow knowledge graph, supporting decision-making across operations, strategy, finance, and risk management domains.