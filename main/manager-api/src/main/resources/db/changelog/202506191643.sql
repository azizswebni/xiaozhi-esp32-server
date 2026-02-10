-- LLM intent recognition configuration instructions
UPDATE `ai_model_config` SET
`doc_link` = NULL,
`remark` = 'LLM intent recognition configuration instructions:
1. Uses an independent LLM for intent recognition
2. Defaults to using the selected_module.LLM model
3. Can be configured to use an independent LLM (e.g., the free ChatGLMLLM)
4. Highly versatile, but increases processing time
Configuration instructions:
1. Specify the LLM model to use in the llm field
2. If not specified, the selected_module.LLM model will be used' WHERE `id` = 'Intent_intent_llm';

-- Function call intent recognition configuration instructions
UPDATE `ai_model_config` SET
`doc_link` = NULL,
`remark` = 'Function call intent recognition configuration instructions:
1. Uses the LLM function_call feature for intent recognition
2. Requires the selected LLM to support function_call
3. Calls tools on demand, fast processing speed' WHERE `id` = 'Intent_function_call';
