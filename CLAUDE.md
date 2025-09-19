# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Goldenberry Knowledge Graph is a Neo4j-based business modeling framework that combines the Business Model Canvas with Jobs-to-be-Done (JTBD) theory. The framework creates comprehensive knowledge graphs for strategic business analysis enhanced with semantic descriptions from authoritative business literature.

## Architecture

### Core Components

- **`core/`** - Contains the foundational schema definition (`schema_definition.md`) with 12 node types and 15+ relationship types
- **`templates/`** - Cypher templates for creating nodes (`node_templates.cypher`) and relationships (`relationship_templates.cypher`)
- **`examples/`** - Complete business model implementations, including CycleWorks Bike Shop demonstration
- **`mermaid/`** - Visualization files for graph representation

### Framework Structure

The framework implements a **three-layer semantic information structure**:
1. **Semantic Description** - Authoritative definitions from business literature
2. **Theoretical Foundation** - Academic research background and citations
3. **Practical Application** - Implementation categories and success frameworks

### Node Types (12 Total)
- `BusinessModel` - Central entity
- `ValueProposition` - Products/services offered
- `CustomerSegment` - Target customer groups
- `JobExecutor` - JTBD: Person executing the job
- `JobToBeDone` - JTBD: Functional job to accomplish
- `Channel` - Communication and distribution paths
- `CustomerRelationship` - Relationship types with customers
- `RevenueStream` - Revenue generation methods
- `KeyResource` - Critical business assets
- `KeyActivity` - Essential business operations
- `KeyPartnership` - Strategic partner network
- `CostStructure` - Business cost categories

### Key Relationships
- Business Model Canvas relationships (13 types)
- JTBD Integration relationships (4 types)
- Cost attribution relationships (3 types)

## Working with Cypher Files

### Development Workflow

1. **Start with Templates**: Use `templates/node_templates.cypher` and `templates/relationship_templates.cypher` as starting points
2. **Reference Schema**: Review `core/schema_definition.md` for complete node properties and relationship definitions
3. **Study Examples**: Examine `examples/CycleWorks_Bike_Shop/` for implementation patterns
4. **Validate Implementation**: Use validation queries from example directories

### File Naming Conventions

- Node templates: `node_templates.cypher`
- Relationship templates: `relationship_templates.cypher`
- Complete models: `[business_name]_complete_model.cypher`
- Validation queries: `validation_queries.cypher`

### Required Neo4j Setup

All Cypher files assume:
- Neo4j database instance (local or cloud)
- Cypher query language capability
- Graph database with APOC procedures for advanced operations

## Semantic Enhancement

Each node contains research-based semantic descriptions from:
- **Alexander Osterwalder & Yves Pigneur**: Business Model Canvas (2005-2010)
- **Clayton Christensen**: Jobs-to-be-Done Theory (Harvard Business School)
- **Anthony Ulwick**: Outcome-Driven Innovation (Strategyn, 1990-present)
- **Harvard Business Review**: Peer-reviewed business research

## Common Development Tasks

### Creating a New Business Model

1. Copy `templates/node_templates.cypher` as starting point
2. Customize node properties for your business context
3. Use `templates/relationship_templates.cypher` to connect nodes
4. Validate using queries from examples directory
5. Ensure all 12 node types and core relationships are included

### Validation Requirements

- Every CustomerSegment must have JobExecutor and JobToBeDone
- Every ValueProposition must address at least one JobToBeDone
- All 3 channel types required (acquisition, delivery, retention)
- All costs must be attributed to sources (resource, activity, channel)

### Schema Completeness

- 12 node types must be present
- 15+ relationship types must be represented
- JTBD integration must be complete for all customer segments
- Semantic enhancement properties should be preserved

## File Organization

When creating new business models:
- Place complete models in `examples/[BusinessName]/`
- Include README.md with business context
- Provide validation queries
- Follow the CycleWorks example structure

## Python Environment Configuration

**Python Setup for Excel Integration:**
- **Environment**: Anaconda base1 environment
- **Python Path**: `C:\Users\jprob\anaconda3\envs\base1\python.exe`
- **Usage**: For Excel file reading and data processing tasks
- **Required Libraries**: pandas, openpyxl (for Excel file operations)

**Always use this Python path for Excel integration tasks:**
```bash
"C:\Users\jprob\anaconda3\envs\base1\python.exe" -c "your_python_code_here"
```

## Integration Notes

This is a pure knowledge modeling framework - no application code, build processes, or testing frameworks are required. All work involves Cypher query development and Neo4j database operations. When Excel integration is needed, use the specified Anaconda Python environment for data processing.