from elevenlabs import ElevenLabs
import json

# Inicializar el cliente
client = ElevenLabs(api_key="sk_a39e6f6589e652f78bbbef5d1e5d276796f5fd9331e984bc")

# Obtener todos los modelos
models = client.models.get_all()

# Convertir los modelos a un formato serializable a JSON
models_serializable = []
for model in models:
    model_dict = {
        "model_id": model.model_id,
        "name": model.name,
        "description": model.description,
        "can_be_finetuned": model.can_be_finetuned,
        "can_do_text_to_speech": model.can_do_text_to_speech,
        "can_do_voice_conversion": model.can_do_voice_conversion,
        "can_use_style": model.can_use_style,
        "can_use_speaker_boost": model.can_use_speaker_boost,
        "serves_pro_voices": model.serves_pro_voices,
        "token_cost_factor": model.token_cost_factor,
        "max_characters_request_free_user": model.max_characters_request_free_user,
        "max_characters_request_subscribed_user": model.max_characters_request_subscribed_user,
        "maximum_text_length_per_request": model.maximum_text_length_per_request,
        "languages": [{"language_id": lang.language_id, "name": lang.name} for lang in model.languages],
        "model_rates": {
            "character_cost_multiplier": model.model_rates.character_cost_multiplier
        },
        "concurrency_group": model.concurrency_group
    }
    models_serializable.append(model_dict)

# Guardar los modelos en un archivo JSON
with open('models_data.json', 'w') as json_file:
    json.dump(models_serializable, json_file, indent=4)
    