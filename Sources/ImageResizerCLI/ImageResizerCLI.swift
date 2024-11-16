import Foundation
import ArgumentParser
import CoreImage
import AppKit

@main
struct ImageResizerCLI: ParsableCommand {
    @Argument(help: "Ruta a la carpeta de entrada")
    var inputPath: String

    @Argument(help: "Ruta a la carpeta de salida")
    var outputPath: String

    func run() throws {
        let inputFolder = URL(fileURLWithPath: inputPath)
        let outputFolder = URL(fileURLWithPath: outputPath)

        do {
            try FileManager.default.createDirectory(at: inputFolder, withIntermediateDirectories: true)
            try FileManager.default.createDirectory(at: outputFolder, withIntermediateDirectories: true)
        } catch {
            print("❌ Error al crear los directorios: \(error)")
            return
        }

        let ciContext = CIContext()

        func resizeImage(at url: URL, targetScale: CGFloat, suffix: String, outputFolder: URL) {
            guard targetScale > 0 else {
                print("⚠️ La escala debe ser mayor a 0")
                return
            }

            guard let image = CIImage(contentsOf: url) else {
                print("⚠️ No se pudo cargar la imagen \(url.lastPathComponent)")
                return
            }
            
            guard let lanczosFilter = CIFilter(name: "CILanczosScaleTransform") else {
                    print("⚠️ No se pudo crear el filtro Lanczos")
                    return
                }

            lanczosFilter.setValue(image, forKey: kCIInputImageKey)
            lanczosFilter.setValue(targetScale, forKey: kCIInputScaleKey)
            lanczosFilter.setValue(1.0, forKey: kCIInputAspectRatioKey)

            guard let outputImage = lanczosFilter.outputImage else {
                print("⚠️ Error al aplicar el filtro Lanczos a \(url.lastPathComponent)")
                return
            }

            guard let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) else {
                print("⚠️ Error al crear la imagen procesada \(url.lastPathComponent)")
                return
            }

            let resizedImage = NSImage(cgImage: cgImage, size: NSSize(width: outputImage.extent.width, height: outputImage.extent.height))

            guard let tiffData = resizedImage.tiffRepresentation,
                  let bitmapRep = NSBitmapImageRep(data: tiffData),
                  let pngData = bitmapRep.representation(using: .png, properties: [:]) else {
                print("⚠️ No se pudo crear el PNG de \(url.lastPathComponent)")
                return
            }

            let sanitizedFileName = url.deletingPathExtension().lastPathComponent.replacingOccurrences(of: " ", with: "_")
            let outputURL = outputFolder.appendingPathComponent("\(sanitizedFileName)\(suffix).png")
            do {
                try pngData.write(to: outputURL)
                print("✅ Imagen redimensionada: \(outputURL.lastPathComponent)")
            } catch {
                print("❌ Error al guardar la imagen: \(error)")
            }
        }

        do {
            let files = try FileManager.default.contentsOfDirectory(at: inputFolder, includingPropertiesForKeys: nil)
            for file in files where file.pathExtension.lowercased() == "png" {
                print("🔄 Procesando: \(file.lastPathComponent)")
                resizeImage(at: file, targetScale: 3.0, suffix: "@1x", outputFolder: outputFolder)
                resizeImage(at: file, targetScale: 1.5, suffix: "@2x", outputFolder: outputFolder)
                resizeImage(at: file, targetScale: 1.0, suffix: "@3x", outputFolder: outputFolder)
            }
        } catch {
            print("❌ Error al leer la carpeta de entrada: \(error)")
        }

        print("✨ ¡Redimensionamiento completo!")
    }
}
