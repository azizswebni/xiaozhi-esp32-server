package xiaozhi.modules.voiceclone.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import xiaozhi.common.page.PageData;
import xiaozhi.common.service.BaseService;
import xiaozhi.modules.voiceclone.dto.VoiceCloneDTO;
import xiaozhi.modules.voiceclone.dto.VoiceCloneResponseDTO;
import xiaozhi.modules.voiceclone.entity.VoiceCloneEntity;

/**
 * Voice Clone Management
 */
public interface VoiceCloneService extends BaseService<VoiceCloneEntity> {

    /**
     * Paginated query
     */
    PageData<VoiceCloneEntity> page(Map<String, Object> params);

    /**
     * Save voice clone
     */
    void save(VoiceCloneDTO dto);

    /**
     * Batch delete
     */
    void delete(String[] ids);

    /**
     * Get voice clone list by user ID
     * 
     * @param userId User ID
     * @return Voice clone list
     */
    List<VoiceCloneEntity> getByUserId(Long userId);

    /**
     * Paginated query with model name and user name
     */
    PageData<VoiceCloneResponseDTO> pageWithNames(Map<String, Object> params);

    /**
     * Get voice clone info by ID with model name and user name
     */
    VoiceCloneResponseDTO getByIdWithNames(String id);

    /**
     * Get voice clone list by user ID with model name
     */
    List<VoiceCloneResponseDTO> getByUserIdWithNames(Long userId);

    /**
     * Upload audio file
     */
    void uploadVoice(String id, MultipartFile voiceFile) throws Exception;

    /**
     * Update voice clone name
     */
    void updateName(String id, String name);

    /**
     * Get audio data
     */
    byte[] getVoiceData(String id);

    /**
     * Clone audio, call Volcano Engine for voice replication training
     * 
     * @param cloneId Voice clone record ID
     */
    void cloneAudio(String cloneId);
}
