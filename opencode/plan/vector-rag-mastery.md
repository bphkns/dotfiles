# Plan: Master Advanced Vector DB & Agentic RAG

**Goal:** Build a "Very Advanced" Agentic RAG system for Financial Fraud Detection using Structured Data.
**Stack:** TypeScript, Bun, Effect-TS, `@effect/schema`, Qdrant (Docker), OpenAI.
**Location:** `libs/api/rag`

## Phase 1: Foundations & Infrastructure

- **Concepts:** High-dimensional vectors, Dot Product vs Cosine, Embeddings.
- **Infrastructure:**
  - [x] Add `qdrant/qdrant` to `docker-compose.yml` (free, local).
  - [x] Create new library `libs/api/rag`.
  - [ ] **Dependency Management:** Add `openai`, `@qdrant/js-client-rest` to `pnpm-workspace.yaml` catalog and library.
  - [ ] **Environment:** Configure `OPENAI_API_KEY`, `QDRANT_HOST`, `QDRANT_API_KEY` in `.env`.
- **Code Structure:**
  - [ ] Define Domain Models (Transaction, User) using `@effect/schema`.
  - [ ] Setup `QdrantClient` Layer in Effect (wrapper around REST client).
  - [ ] Setup `OpenAIClient` Layer (embeddings).
- **Task:** Manually generate embeddings (OpenAI) and perform a raw similarity search without the DB to verify "naive" baselines.

## Phase 2: The Vector Engine (Qdrant Deep Dive)

- **Concepts:** HNSW (Navigable Small Worlds), Quantization (Binary/Scalar).
- **Implementation:**
  - Configure Qdrant Collection with **Binary Quantization** (32x compression) and **HNSW** tuning (`m`, `ef_construct`).
  - Implement "Matryoshka Representation Learning" (MRL) compatible schema (if supported by model) or standard optimization.
- **Ingestion Pipeline:**
  - Generate synthetic "Financial Fraud" dataset (JSON: amount, location, merchant, notes).
  - Build `IngestionService` using Effect Streams to chunk and upsert data efficiently.

## Phase 3: RAG for Structured Data (The "Hard" Part)

- **Concepts:** Self-Querying, Pre-filtering vs Post-filtering.
- **Implementation:**
  - **Self-Querying Retriever:** Use LLM to transform natural language query into a structured Qdrant Filter.
    - _Input:_ "Show me large transfers to offshore accounts last week."
    - _Output:_ Filter `{ type: "transfer", amount: { gt: 10000 }, country: { neq: "US" } }` + Vector Search "offshore account".
  - **Hybrid Search:** Implement Reciprocal Rank Fusion (RRF) combining BM25 (Keyword) and Dense Vector scores.

## Phase 4: Agentic Workflow (The Brain)

- **Concepts:** Agentic RAG, Router Pattern, Critique-and-Refine.
- **Implementation:**
  - **Router Agent:** Classifies query intent -> `SQL_Aggregator` vs `Vector_Search` vs `Direct_Answer`.
  - **Refinement Loop:**
    1.  **Retrieve:** Fetch context.
    2.  **Critique:** LLM grades relevance (0-1).
    3.  **Refine:** If grade < 0.7, rewrite query and retry (max 3 hops).

## Phase 5: GraphRAG (God Tier)

- **Concepts:** Knowledge Graphs + Vector Search.
- **Implementation:**
  - **Entity Linking:** Extract entities (Users, Merchants) and link them in Qdrant (using Payload references or a lightweight Graph structure).
  - **Graph Traversal:** "Who transferred money to a user who visited a high-risk merchant?"
    - Step 1: Find high-risk merchant (Vector).
    - Step 2: Find users visiting merchant (Graph/Link).
    - Step 3: Find transfers to those users (Graph/Link).

## Implementation Checklist

- [ ] **Setup:** Docker Qdrant, `libs/api/rag`, OpenAI SDK.
- [ ] **Schema:** `@effect/schema` for Transaction/User.
- [ ] **Ingestion:** Effect Stream pipeline for 10k records.
- [ ] **Retriever:** Self-Querying + Hybrid Search service.
- [ ] **Agent:** Router + Critique Loop using Effect.
- [ ] **Graph:** explicit entity linking and multi-hop retrieval.
