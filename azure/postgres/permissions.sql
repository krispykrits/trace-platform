\set ON_ERROR_STOP on

-- Run as the Entra PostgreSQL administrator against the postgres database.
-- Supply api_object_id and worker_object_id as psql variables. The identities
-- are non-admin roles; the source package and authorization grants are read-only.
BEGIN;
SELECT * FROM pg_catalog.pgaadauth_create_principal_with_oid(
  'id-trace-api-dev-wus3', :'api_object_id', 'service', false, false
);
SELECT * FROM pg_catalog.pgaadauth_create_principal_with_oid(
  'id-trace-worker-dev-wus3', :'worker_object_id', 'service', false, false
);
COMMIT;

\connect trace_dev
BEGIN;
GRANT CONNECT ON DATABASE trace_dev TO "id-trace-api-dev-wus3", "id-trace-worker-dev-wus3";
GRANT USAGE ON SCHEMA public TO "id-trace-api-dev-wus3", "id-trace-worker-dev-wus3";

GRANT SELECT ON trace_source_packages, trace_principal_grants TO "id-trace-api-dev-wus3", "id-trace-worker-dev-wus3";
GRANT UPDATE (lock_marker) ON trace_principal_grants TO "id-trace-api-dev-wus3", "id-trace-worker-dev-wus3";

GRANT SELECT, INSERT, UPDATE ON trace_jobs TO "id-trace-api-dev-wus3";
GRANT SELECT, UPDATE ON trace_job_attempts TO "id-trace-api-dev-wus3";
GRANT SELECT ON trace_workflow_artifacts TO "id-trace-api-dev-wus3";

GRANT SELECT, UPDATE ON trace_jobs TO "id-trace-worker-dev-wus3";
GRANT SELECT, INSERT, UPDATE ON trace_job_attempts, trace_workflow_runs, trace_execution_runs, trace_execution_calls, trace_model_attempts TO "id-trace-worker-dev-wus3";
GRANT SELECT, INSERT ON trace_snapshots, trace_workflow_artifacts TO "id-trace-worker-dev-wus3";
GRANT SELECT ON trace_model_budget, trace_model_months TO "id-trace-worker-dev-wus3";
GRANT UPDATE (lock_marker) ON trace_model_budget TO "id-trace-worker-dev-wus3";
GRANT INSERT ON trace_model_redactions TO "id-trace-worker-dev-wus3";
GRANT USAGE ON SEQUENCE trace_job_attempts_attempt_id_seq, trace_workflow_artifacts_ordinal_seq TO "id-trace-worker-dev-wus3";
COMMIT;
