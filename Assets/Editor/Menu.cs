using UnityEditor;
using UnityEngine;
public class Menu : MonoBehaviour
{
    [MenuItem("LiwenDebugMode/All")]
    static void DoAll()
    {
        Shader.SetGlobalInt("_Mode", 0);
    }

    [MenuItem("LiwenDebugMode/Depth")]
    static void DoDepth()
    {
        Shader.SetGlobalInt("_Mode", 1);
    }

    [MenuItem("LiwenDebugMode/Normal")]
    static void DoNormal()
    {
        Shader.SetGlobalInt("_Mode", 2);
    }

    [MenuItem("LiwenDebugMode/Thickness")]
    static void DoThickness()
    {
        Shader.SetGlobalInt("_Mode", 3);
    }

    [MenuItem("LiwenDebugMode/Tangent")]
    static void DoTangent()
    {
        Shader.SetGlobalInt("_Mode", 4);
    }

    [MenuItem("LiwenDebugMode/Reflection")]
    static void DoReflection()
    {
        Shader.SetGlobalInt("_Mode", 5);
    }

    [MenuItem("LiwenDebugMode/Refraction")]
    static void DoRefraction()
    {
        Shader.SetGlobalInt("_Mode", 6);
    }

    [MenuItem("LiwenDebugMode/Phong specular highlight")]
    static void DoHighlight()
    {
        Shader.SetGlobalInt("_Mode", 7);
    }
}
