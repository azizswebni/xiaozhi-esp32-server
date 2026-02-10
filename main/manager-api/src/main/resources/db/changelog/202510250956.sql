-- Add RAG model provider and configuration
-- -------------------------------------------------------

-- Add RAG model provider
delete from `ai_model_provider` where id = 'SYSTEM_RAG_ragflow';
INSERT INTO `ai_model_provider` (`id`, `model_type`, `provider_code`, `name`, `fields`, `sort`, `creator`, `create_date`, `updater`, `update_date`) VALUES
('SYSTEM_RAG_ragflow', 'RAG', 'ragflow', 'RAGFlow', '[{"key": "base_url", "type": "string", "label": "Service URL"}, {"key": "api_key", "type": "string", "label": "API Key"}]', 1, 1, NOW(), 1, NOW());

-- Add RAG model configuration
delete from `ai_model_config` where id = 'RAG_RAGFlow';
INSERT INTO `ai_model_config` VALUES ('RAG_RAGFlow', 'RAG', 'ragflow', 'RAGFlow', 1, 1, '{"type": "ragflow", "base_url": "http://localhost", "api_key": "your_rag_key"}', 'https://github.com/infiniflow/ragflow/blob/main/README_zh.md', 'RAGFlow configuration guide:
1. Quick deployment tutorial (Docker deployment)
1.$ sysctl vm.max_map_count
2.$ sysctl -w vm.max_map_count=262144
3.$ git clone https://github.com/infiniflow/ragflow.git
4.docker compose -f docker-compose.yml up -d
5.$ docker logs -f docker-ragflow-cpu-1
6.After registering and logging in, click the avatar in the top right corner to obtain the RAGFlow API KEY and API server address. Before using RAGFlow, please add models and set default models in Model Provider.
2. If you want to disable the registration feature
1.Stop service   docker compose down
2. sed -i ''s/REGISTER_ENABLED=1/REGISTER_ENABLED=0/g'' .env
3.cat .env | grep -i register
4.When you see REGISTER_ENABLED=0, restart the service.',  1, NULL, NULL, NULL, NULL);


