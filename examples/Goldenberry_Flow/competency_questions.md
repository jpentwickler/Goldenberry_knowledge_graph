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

20. **How many cost categories, CostStructure nodes, and CostData nodes exist?**
    - Expected: 6 cost categories with time-series data, 33 CostStructure nodes (framework), 99 CostData nodes (actual costs)

21. **What are the main cost categories in the business model?**
    - Expected: Direct Product Costs, Export Operations Overhead, Digital Trust Infrastructure, Trust Administration & Governance, Financial Operations, Risk Management & Contingency

### Financial Performance Questions
22. **What are the revenue stream types and frequencies?**
    - Expected: All revenue streams are asset sale type with per-kg frequency and fixed pricing

23. **How are costs classified by behavior type with actual amounts?**
    - Expected: 60 fixed CostData nodes ($132,580), 39 variable CostData nodes ($1,965,411), 0 mixed in current implementation

### Time-Series Revenue Analysis
24. **What fiscal year does the revenue data cover in the knowledge graph?**
    - Expected: Fiscal Year 2025 (September 2024 - September 2025)

25. **How many TimePeriod nodes exist and what data types do they connect?**
    - Expected: 13 TimePeriod nodes (Sep 2024 - Sep 2025) connecting both revenue data (VolumeData, PriceData) and cost data (CostData)

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
36. **What key resources does each value proposition require?**
    - Expected: Digital Trust Platform requires blockchain infrastructure, legal framework, financial reserves, specialized team; Export Operations requires infrastructure and team

37. **Which activities are critical for delivering the digital trust investment platform?**
    - Expected: Digital Trust Asset Management, Investor Services & Transparency, Financial Operations & Compliance, Trust Operations Administration

38. **How do key activities utilize different key resources?**
    - Expected: Detailed mapping of activity-resource dependencies

### Resource Type Analysis
39. **What type of resources (physical, intellectual, human, financial) are most critical?**
    - Expected: Analysis showing intellectual resources (platform, legal framework) and human resources as most critical

40. **Which resources enable the export operations infrastructure?**
    - Expected: Local operating partners enable physical export infrastructure

---

## Category 6: Partnership Strategy & Ecosystem

### Partnership Value Analysis
41. **What are the key partnerships?**
    - Expected: Primary Operational Partner, Financial & Trust Infrastructure Partners, Technology & Platform Partners, Regulatory & Compliance Partners, Market & Customer Partners

42. **How do partnerships enable key resources and support key activities?**
    - Expected: Partnership-resource and partnership-activity relationship mappings

43. **How many strategic partnerships exist in the business model?**
    - Expected: 5 strategic partnerships across different categories

### Strategic Partnership Questions
44. **Which partnership enables primary operations?**
    - Expected: Primary Operational Partner for Colombian fruit operations and export infrastructure

45. **How does the Estonian legal framework partnership support regulatory compliance?**
    - Expected: Enables EU-compliant legal structure and supports regulatory compliance activities

---

## Category 7: Cost Attribution & Efficiency

### Cost Driver Analysis
46. **Which resources, activities, or channels have cost attribution relationships?**
    - Expected: 6 Key Resources, 13 Key Activities, and 7 Channels have INCURS_COST relationships

47. **What are the specific cost drivers for each major expense category?**
    - Expected: Detailed cost driver descriptions for each cost relationship

48. **What are the blockchain and digital infrastructure cost drivers?**
    - Expected: Platform complexity, smart contract deployment, transaction processing, AI integration, cybersecurity requirements

### Operational Cost Questions
49. **What personnel-related cost structures exist?**
    - Expected: Export Operations Personnel, Trust Operations Administrator (with specific cost drivers for team size, expertise, and operational scope)

50. **Which marketing channels incur the highest acquisition costs?**
    - Expected: Comparison of LinkedIn campaigns, conferences, and trade shows

---

## Category 8: Strategic Business Insights

### Competitive Analysis
51. **What makes this a dual-segment business model architecture?**
    - Expected: Analysis of serving both investors and importers with different value propositions

52. **How does blockchain technology create competitive advantage?**
    - Expected: Smart contract automation, transparency, trust, and compliance advantages

53. **What role does the Estonian regulatory framework play in the business model?**
    - Expected: EU market access, regulatory compliance, fiduciary protection benefits

### Scalability Questions
54. **How does the containerized export model support scalability?**
    - Expected: Container-based operations allow volume scaling and standardized logistics

55. **What are the key differentiators from traditional export businesses?**
    - Expected: Digital trust integration, blockchain governance, investor participation model

---

## Category 9: Risk & Compliance Analysis

### Risk Mitigation
56. **What regulatory compliance activities are required for this business model?**
    - Expected: Estonian framework compliance, blockchain regulations, international trade requirements

57. **How does the digital trust framework mitigate investment risks?**
    - Expected: Smart contracts, automated compliance, real-time transparency, fiduciary protection

58. **What quality assurance mechanisms protect importer relationships?**
    - Expected: Quality control facilities, certification processes, dedicated account management

### Compliance Framework
59. **Which partnerships reduce operational and regulatory risks?**
    - Expected: Estonian legal partners for compliance, local partners for operational risk reduction

60. **How does the legal structure provide fiduciary protection?**
    - Expected: Estonian legal framework with trust structure and regulatory oversight

---

## Category 10: Network Analysis & Relationships

### Graph Structure Analysis
61. **What is the complete network structure connecting business model components?**
    - Expected: Full business model network including 99 CostData nodes, 13 TimePeriod nodes, 437+ total relationships spanning business model components, revenue time-series, and cost time-series

62. **Which nodes have the most relationship connections in the graph?**
    - Expected: Analysis of node centrality and connection density - TimePeriod nodes now central with connections to both revenue and cost data

63. **How are costs attributed throughout the business model network?**
    - Expected: Complete cost attribution network from sources (KeyResource, KeyActivity, Channel) through CostStructure to CostData nodes with time-series detail

### Relationship Pattern Analysis
64. **What is the relationship density between different node types?**
    - Expected: Statistical analysis of relationship patterns across node types, including 237 cost-related relationships

65. **Which components are most central to the business model's operation?**
    - Expected: Centrality analysis identifying critical components like specialized team, digital platform, and TimePeriod nodes as temporal integration points

---

## Category 11: Cost Analysis & Time-Series Data

### Basic Cost Data Questions
66. **How many CostData nodes exist and what is the total cost amount?**
    - Expected: 99 CostData nodes, $2,097,991 total

67. **How are costs classified by behavior type (fixed vs variable)?**
    - Expected: 60 fixed cost nodes ($132,580), 39 variable cost nodes ($1,965,411)

68. **What fiscal period do the cost data cover?**
    - Expected: 13 months from September 2024 to September 2025

69. **How many TimePeriod nodes exist and what do they represent?**
    - Expected: 13 TimePeriod nodes with shared coverage across both revenue and cost data

70. **What new relationship type was introduced for cost-product attribution?**
    - Expected: COST_FOR_PRODUCT relationship (39 instances linking variable costs to products)

71. **How many total cost-related relationships exist in the database?**
    - Expected: 237 relationships (99 COST_FOR_STRUCTURE + 99 INCURRED_IN_PERIOD + 39 COST_FOR_PRODUCT)

72. **What cost categories have actual time-series data loaded?**
    - Expected: 6 categories - Personnel, Setup & Branding, Product Packaging, Certifications, Trade Shows, Product Procurement

73. **Which CostStructure nodes have CostData attribution?**
    - Expected: 6 of 33 CostStructure nodes (cs_export_personnel, cs_setup_costs, cs_container_packaging, cs_certifications_compliance, cs_market_development, cs_fruit_procurement)

### Personnel Cost Analysis
74. **What are the monthly personnel costs and categories?**
    - Expected: $3,600/month across 4 categories (Manager $850, Export Commercial $1,500, Accounting $700, Assistant $550)

75. **How many personnel cost nodes exist and what is their total?**
    - Expected: 52 nodes (4 categories × 13 months), $46,800 total

76. **What is the personnel cost coverage across the fiscal year?**
    - Expected: Complete 13-month coverage with consistent $3,600/month

77. **Which CostStructure receives all personnel cost attribution?**
    - Expected: cs_export_personnel receives all 52 personnel CostData nodes

### One-Time Event Cost Analysis
78. **What one-time events are recorded in the cost data?**
    - Expected: 8 events - 4 setup costs (Sep 2024), 4 trade shows (Sep 2024, Nov 2024, May 2025)

79. **What is the total one-time event cost and how is it distributed?**
    - Expected: $85,780 total - Sep 2024 spike ($49,080), Nov 2024 ($19,300), May 2025 ($17,400)

80. **Which trade shows are represented in the cost data with their costs?**
    - Expected: GPF USA ($8,280), Fruit Attraction ($15,800), Fruit Logistica Berlin ($19,300), Fruit Logistica Asia ($17,400)

81. **What setup costs were incurred at business launch?**
    - Expected: GSS Rebranding ($3,500), Packaging Materials ($10,000), Certifications ($10,000), Commercial Expense ($1,500)

82. **Which months show one-time event cost spikes?**
    - Expected: September 2024 (6 events, $49,080), November 2024 (1 event, $19,300), May 2025 (1 event, $17,400)

### Variable Product Procurement Analysis
83. **How many variable cost nodes exist per product and what are the totals?**
    - Expected: 13 nodes per product - Pitahaya ($988,069), Goldenberries ($912,092), Exotic Fruits ($65,250)

84. **Which product has the highest variable procurement costs?**
    - Expected: Pitahaya with $988,069 (50.3% of variable costs)

85. **How many COST_FOR_PRODUCT relationships exist per product?**
    - Expected: 13 relationships per product (39 total across 3 products)

86. **What is the monthly trend for variable procurement costs?**
    - Expected: Increasing trend from $12,668 (Sep 2024) to $292,796 (Sep 2025)

87. **How are variable costs different from fixed costs in terms of relationships?**
    - Expected: Variable costs have 3 relationships per node (vs 2 for fixed), adding COST_FOR_PRODUCT

88. **Which months have zero variable costs for specific products?**
    - Expected: Goldenberries $0 (Sep 2024), Exotic Fruits $0 (Sep-Oct 2024)

89. **What is the product-level cost distribution for variable costs?**
    - Expected: Pitahaya 50.3%, Goldenberries 46.4%, Exotic Fruits 3.3%

### Cost-Revenue Integration Analysis
90. **How do TimePeriod nodes integrate cost and revenue data?**
    - Expected: Same 13 TimePeriod nodes connect to both CostData (via INCURRED_IN_PERIOD) and VolumeData/PriceData (via OCCURS_IN_PERIOD/PRICED_IN_PERIOD)

91. **What is the monthly profit/loss for each period?**
    - Expected: Revenue minus costs per month - Sep 2024 shows loss due to setup spike, profitable from Oct onwards

92. **Which month shows the highest cost-to-revenue ratio?**
    - Expected: September 2024 due to $49,080 one-time setup spike

93. **What is the total annual profit (revenue minus costs)?**
    - Expected: $2,269,183.63 (revenue) - $2,097,991 (costs) = $171,192.63 annual profit

94. **When does the business reach break-even on cumulative basis?**
    - Expected: December 2024 (after recovering from September setup costs)

95. **How do variable costs correlate with revenue volume trends?**
    - Expected: Variable costs increase with volume - both show growth from Sep 2024 to Sep 2025

### Product-Level Profitability Analysis
96. **What is the gross profit per product (revenue minus variable costs)?**
    - Expected: Pitahaya: $1,163,570 - $988,069 = $175,501; Goldenberries: $1,033,114 - $912,092 = $121,022; Exotic Fruits: $72,500 - $65,250 = $7,250

97. **Which product has the highest gross profit margin?**
    - Expected: Pitahaya with 15.1% margin, Goldenberries 11.7%, Exotic Fruits 10.0%

98. **How are fixed costs allocated vs variable costs attributed to products?**
    - Expected: Fixed costs ($132,580) shared across all products, variable costs ($1,965,411) directly attributed via COST_FOR_PRODUCT

99. **What is the contribution margin per kg for each product?**
    - Expected: Price/kg minus variable cost/kg for each product

100. **Which product generates the best return on variable cost investment?**
     - Expected: Analysis of revenue/variable cost ratio per product

101. **How do product-level costs evolve month-over-month?**
     - Expected: Trend analysis showing Pitahaya and Goldenberries scaling, Exotic Fruits steady

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

---

## Summary Statistics

**Total Competency Questions**: 101 (updated from 52)
**New Questions Added**: 36 (Category 11: Cost Analysis & Time-Series Data)
**Updated Questions**: 4 (Questions 20, 23, 25, 61)
**Categories**: 11 (added Category 11)

### Question Distribution by Category
- Category 1: Business Model Structure & Validation - 7 questions
- Category 2: Customer Analysis & JTBD Integration - 12 questions
- Category 3: Channel Strategy & Customer Relationships - 10 questions
- Category 4: Revenue & Financial Analysis - 18 questions
- Category 5: Resource Dependencies & Operations - 5 questions
- Category 6: Partnership Strategy & Ecosystem - 5 questions
- Category 7: Cost Attribution & Efficiency - 5 questions
- Category 8: Strategic Business Insights - 5 questions
- Category 9: Risk & Compliance Analysis - 5 questions
- Category 10: Network Analysis & Relationships - 5 questions
- Category 11: Cost Analysis & Time-Series Data - 36 questions (NEW)

### Key Capabilities Demonstrated
- Complete business model canvas analysis with JTBD integration
- Revenue time-series analysis with fixed pricing validation
- **Cost time-series analysis with fixed/variable classification (NEW)**
- **Product-level profitability analysis (NEW)**
- **Cost-revenue integration and break-even analysis (NEW)**
- **Monthly financial performance tracking (NEW)**
- Strategic partnership and resource dependency mapping
- Network analysis across 437+ relationships

This competency question framework enables AI agents to provide comprehensive business intelligence and strategic insights from the Goldenberry Flow knowledge graph, supporting decision-making across operations, strategy, finance, risk management, and profitability analysis domains.